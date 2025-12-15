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

	public string DisplayHp => Mathf.RoundToInt(Mathf.Max(1f, hp)).ToString();

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

	[Export]
	public ActorSynchronizer synchronizer;

	[Export]
	public CollisionShape3D collisionShape;

	public CapsuleShape3D capsuleShape;

	[Export]
	public ActorAnimator _animator;

	[Export]
	public AnimatedSprite3D sprite;

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

	/**
	 * @TODO Maybe turn all damagers to collider based detection?
	 */
	public bool TryAttackArea(ActionSetup actionSetup, Actor target, Vector3 attackPosition, float range = 1f) {
		if (!Multiplayer.IsServer()) {
			return false;
		}

		if (target.GlobalPosition.DistanceTo(attackPosition) > range) {
			return false; // Target moved away.
		}

		var hitChance = stats.GetHitChance(target);
		if (GD.Randf() > hitChance) {
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

		target.Damage(damage, isCritical);

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

	public void Damage(float damage, bool isCritical, int hitCount = 0) {
		var newHp = Mathf.Max(0f, hp - damage);

		Rpc(nameof(RpcDamage), damage, newHp, isCritical, hitCount);
	}

	[Rpc(CallLocal = true)]
	public void RpcDamage(float damage, float newHp, bool isCritical, int hitCount) {
		hp = newHp;

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
			stateMachine.Force("Hit");

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

	private void OnCreated(uint actorId) {
		isPlayer = synchronizer.playerId == Multiplayer.GetUniqueId();
		Position = synchronizer.spawnPosition;

		setup = _setups.GetSetup(actorId);
		sprite.SpriteFrames = setup.AnimationFrames;

		// GD.Print($"Created with {actorId} / {setup.name} at {synchronizer.spawnPosition} / {Position}");

		var spriteOffset = sprite.PixelSize * setup.SpritePixels / 2f;

		sprite.Position = new Vector3(0f, spriteOffset, 0f);
		sprite.Play("Idle");

		var height = Height;

		collisionShape.Position = new Vector3(0f, height * 0.5f , 0f);
		capsuleShape.Height = height ;
		capsuleShape.Radius = height / 4f; // May require customization for certain actors.
		shadow.Scale = new Vector3(1f, 1f, 1f) * setup.SpritePixels / 35f;

		stats = setup.BaseStats.Clone;

		// @TODO Maybe sync all stats for having a unified system.
		if (!IsPlayerGroup) {
			stats.vitality = synchronizer.vitality;
		}

		hp = stats.vitality;
		sp = stats.intelligence;

		ActorAvatars.instance.Add(this);

		_animator.FadeIn();

		if (isPlayer) {
			PlayerController.instance.Begin(this);
			CameraController.instance.Follow(this);
		}

		if (IsPlayerGroup && Multiplayer.IsServer()) {
			hp -= 50; // @TODO Remove, temp for regen testing.
			sp -= 35;

			_regenerate.Start();
		}
	}

	public void OnDeath() {
		_animator.FadeOut();

		collisionShape.Disabled = true;
		actors.Remove(this);

		ActorAvatars.instance.Remove(this);

		Death?.Invoke();
	}
}