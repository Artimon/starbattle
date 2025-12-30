using System;
using System.Collections.Generic;
using System.Linq;
using Artimus.Services;
using Godot;
using Starbattle.Controllers;

namespace Starbattle;

[GlobalClass]
public partial class Actor : Node3D {
	public static readonly List<Actor> actors = new (16);

	public bool isPlayer;

	public Stats stats;

	public float hp;
	public float MaxHp => stats.MaxHp;

	public string DisplayHp => Mathf.CeilToInt(hp).ToString();

	public float sp;
	public float MaxSp => stats.MaxSp;

	public bool IsHpMissing => hp < MaxHp;
	public bool IsSpMissing => sp < MaxSp;
	public bool IsDead => hp <= 0f;

	/**
	 * @TODO Does not consider summons, yet.
	 */
	public bool IsPlayerGroup => synchronizer.playerId != 0;

	public float angle;

	public float actionRange = 4.5f;

	public Actor counterTarget;

	[Export]
	public ActorSynchronizer synchronizer;

	[Export]
	public Node3D displayNode;

	[Export]
	public CharacterBody3D characterBody;

	[Export]
	public CollisionShape3D collisionShape;

	public CapsuleShape3D capsuleShape;

	[Export]
	public ActorAnimator _animator;

	[Export]
	public AnimatedSprite3D sprite;

	[Export]
	public Node3D spriteContainer;

	[Export]
	public Sprite3D shadow;

	public float Height => sprite.PixelSize * setup.pixelHeight;

	public float EffectScale => setup.pixelHeight / 80f;

	public Vector3 CameraTarget => GlobalPosition;

	public Vector3 GlobalCenter => collisionShape.GlobalPosition;

	public float SpriteSize => setup.SpritePixels * sprite.PixelSize;

	public ActorSetup setup;

	[Export]
	public ActorSetups _setups;

	public ActorSetups Setups => _setups;

	[Export]
	public ActorAction action;

	[Export]
	public ActorPoise poise;

	[Export]
	public ActorBehaviour behaviour;

	[Export]
	public ActorExperience experience;

	[Export]
	public ActorPerks perks;

	[Export]
	public ActorRegenerate _regenerate;

	[Export]
	public StateMachine stateMachine;

	[Export]
	public PackedScene _combatNumberPrefab;

	[Export]
	public PackedScene _combatMessagePrefab;

	public event Action Death;

	public static Actor[] EnemyGroup => actors.Where(actor => !actor.IsPlayerGroup).ToArray();

	/**
	 * @TODO Requires re-check to exclude usage for summons.
	 */
	public static Actor[] PlayerGroup => actors.Where(actor => actor.IsPlayerGroup).ToArray();

	public override void _EnterTree() {
		actors.Add(this);

		capsuleShape = collisionShape.Shape as CapsuleShape3D;

		// Warning: Synchronizer fields are not set yet!

		// Does not get called on the server!
		// synchronizer.DeltaSynchronized += () => {
		// 	GD.Print($"Actor (delta) synchronized: {synchronizer.handle} / {synchronizer.playerId} ({Multiplayer.GetUniqueId()})");
		// };
	}

	/**
	 * Initially set synchronized data is available here.
	 */
	public override void _Ready() {
		OnCreated(synchronizer.actorId);
		// GD.Print($"My network handle: {synchronizer.handle} / {synchronizer.ownerId} ({Multiplayer.GetUniqueId()})");
	}

	// public override void _Process(double delta) {
	// 	GD.Print($"ActorID on {Multiplayer.GetUniqueId()}: {synchronizer.actorId}");
	// }

	public void Face(Actor actor) {
		Face(actor.GlobalPosition);
	}

	public void Face(Vector3 position) {
		var direction = position - GlobalPosition;

		angle = Mathf.Atan2(direction.X, direction.Z);
		ApplyAngle();
	}

	public bool TryHit(Actor target) {
		var hitChance = stats.GetHitChance(target);
		if (GD.Randf() < hitChance) {
			return true;
		}

		// 0.1% lucky hit chance per luck point.
		var luckyHitChance = Mathf.Clamp(stats.luck / 1000f, 0f, 0.20f);
		if (GD.Randf() < luckyHitChance) {
			return true;
		}

		return false;
	}

	/**
	 * @TODO Maybe turn all damagers to collider based detection?
	 */
	public bool TryAttackArea(ActionSetup actionSetup, Actor target, Vector3 attackPosition, float range = 1.5f) {
		if (!Multiplayer.IsServer()) {
			return false;
		}

		if (target.GlobalPosition.DistanceTo(attackPosition) > range) {
			return false; // Target moved away.
		}

		var isHit = TryHit(target);
		if (!isHit) {
			target.Message(CombatMessage.Types.Miss);

			return false;
		}

		// base + 5 * (lvl + 1)
		// var weaponpDam[4] = 40, 40, 20, 15;	// Weapon basic values for all player classes
		// var weaponmDam[4] =  0, 30, 35, 40;

		var damage = stats.GetPhysicalDamage(actionSetup.power, target);

		var isCritical = false;
		var critChance = stats.CritChance;

		if (GD.Randf() < critChance) {
			isCritical = true;
			damage *= 1.5f;
		}

		target.Damage(this, damage, isCritical);

		return true;
	}

	public void Message(CombatMessage.Types type) {
		Rpc(nameof(RpcMessage), (int)type);
	}

	[Rpc(CallLocal = true)]
	public void RpcMessage(int type) {
		_combatMessagePrefab.Instantiate<CombatMessage>(EffectContainer.instance)
			.ShowMessage(this, (CombatMessage.Types)type);
	}

	public void Damage(Actor attacker, float damage, bool isCritical, int hitCount = 0) {
		var counterChance = stats.CounterChance;
		if (GD.Randf() < counterChance) {
			counterTarget = attacker;
		}

		var newHp = Mathf.Max(0f, hp - damage);
		if (newHp > 0f) {
			poise.ApplyPoise(damage, out var isStaggered);

			if (isStaggered) {
				action.TryRequestHit();
			}
		}

		Rpc(nameof(RpcDamage), damage, newHp, isCritical, hitCount);
	}

	[Rpc(CallLocal = true)]
	public void RpcDamage(float damage, float newHp, bool isCritical, int hitCount) {
		hp = newHp;

		_animator.Hit(damage);
		_combatNumberPrefab.Instantiate<CombatNumberBounce>(EffectContainer.instance)
			.ShowDamage(this, damage, isCritical, hitCount);

		if (isCritical) {
			_combatMessagePrefab.Instantiate<CombatMessage>(EffectContainer.instance)
				.ShowMessage(this, CombatMessage.Types.Critical);
		}

		// @TODO Show damage and crit on screen.
		// if (Multiplayer.IsServer()) {
		// 	GD.Print($"Damage dealt: {damage}, {hp}/{stats.Vitality} (crit: {isCritical})");
		// }

		if (hp > 0f) {
			return;
		}

		if (stateMachine.IsInState("Die")) {
			return;
		}

		stateMachine.Force("Die");
	}

	public void Heal(float heal, bool showNumber) {
		if (heal == 0f) {
			return;
		}

		var newHp = Mathf.Min(MaxHp, hp + heal);

		Rpc(nameof(RpcHeal), heal, newHp, showNumber);
	}

	[Rpc(CallLocal = true)]
	public void RpcHeal(float heal, float newHp, bool showNumber) {
		hp = newHp;

		if (!showNumber) {
			return;
		}

		_combatNumberPrefab.Instantiate<CombatNumberBounce>(EffectContainer.instance)
			.ShowHeal(this, heal);
	}

	public void Drain(float drain) {
		if (drain == 0f) {
			return;
		}

		var newSp = Mathf.Max(0f, sp - drain);

		Rpc(nameof(RpcSpChange), drain, newSp, false);
	}

	public void Refresh(float refresh, bool showNumber) {
		if (refresh == 0f) {
			return;
		}

		var newSp = Mathf.Min(MaxSp, sp + refresh);

		Rpc(nameof(RpcSpChange), refresh, newSp, showNumber);
	}

	[Rpc(CallLocal = true)]
	public void RpcSpChange(float refresh, float newSp, bool showNumber) {
		sp = newSp;

		if (!showNumber) {
			return;
		}

		_combatNumberPrefab.Instantiate<CombatNumberBounce>(EffectContainer.instance)
			.ShowRefresh(this, refresh);
	}

	public void ApplyAngle() {
		var cameraAngle = CameraController.instance.Angle;
		var angleToCamera = angle - cameraAngle;

		sprite.FlipH = Mathf.Sin(angleToCamera) > 0f;
	}

	public static Actor Resolve(uint handle) => actors.Find(actor => actor.synchronizer.handle == handle);

	public void FullHeal() {
		if (!Multiplayer.IsServer()) {
			return;
		}

		var heal = MaxHp - hp;
		Heal(heal, false);

		var refresh = MaxSp - sp;
		Refresh(refresh, false);
	}

	private void OnCreated(uint actorId) {
		isPlayer = synchronizer.playerId == Multiplayer.GetUniqueId();
		Position = synchronizer.spawnPosition;

		behaviour.Register();
		setup = _setups.GetSetup(actorId);
		sprite.SpriteFrames = setup.AnimationFrames;
		sprite.Play("Idle");

		// GD.Print($"Created with {actorId} / {setup.name} at {synchronizer.spawnPosition} / {Position}");

		var spriteOffset = sprite.PixelSize * setup.SpritePixels / 2f;

		spriteContainer.Position = new Vector3(0f, spriteOffset, 0f);

		var height = Height;

		characterBody.CollisionLayer = TargetingController.instance.GetActorMask(this);
		characterBody.CollisionMask = characterBody.CollisionLayer;

		collisionShape.Position = new Vector3(0f, height * 0.5f , 0f);
		capsuleShape.Height = height ;
		capsuleShape.Radius = height / 4f; // May require customization for certain actors.
		shadow.Scale = new Vector3(1f, 1f, 1f) * setup.SpritePixels / 35f;

		stats = setup.BaseStats;
		synchronizer.SyncStats(); // Overwrite cloned stats with actual values.

		hp = stats.vitality;
		sp = stats.wisdom;

		ActorAvatars.instance.Add(this);

		_animator.FadeIn();

		if (isPlayer) {
			PlayerController.instance.Begin(this);
			CameraController.instance.Follow(this);
		}

		if (IsPlayerGroup && Multiplayer.IsServer()) {
			// hp -= 50; // @TODO Remove, temp for regen testing.
			// sp -= 35;

			_regenerate.Start();
		}
	}

	public void OnDeath() {
		if (IsPlayerGroup) {
			return; // @TODO Add proper player ko handling.
		}

		_animator.FadeOut();

		collisionShape.Disabled = true;
		actors.Remove(this);

		ActorAvatars.instance.Remove(this);

		Death?.Invoke();
	}
}