using System;
using System.Collections.Generic;
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
	public float mp;

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
	public StateMachine stateMachine;

	[Export]
	public PackedScene _damageNumberPrefab;

	public event Action Death;

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
	public bool TryAttackArea(Actor target, Vector3 attackPosition, float range = 1f) {
		if (!Multiplayer.IsServer()) {
			return false;
		}

		if (target.GlobalPosition.DistanceTo(attackPosition) > range) {
			return false; // Target moved away.
		}

		// base + 5 * (lvl + 1)
		// var weaponpDam[4] = 40, 40, 20, 15;	// Weapon basic values for all player classes
		// var weaponmDam[4] =  0, 30, 35, 40;

		var baseDamage = 45; // @TODO Read from stats/weapon.

		var statsFactor = 0.5f + stats.Strength / 200f;
		var randomFactor = 1f + GD.Randf() * 0.5f; // @TODO Use Gauss later.
		var damage = baseDamage * statsFactor * randomFactor;

		var isCritical = false;
		var critChance = stats.Dexterity * 0.25f / 100f;

		if (GD.Randf() < critChance) {
			isCritical = true;
			damage *= 1.5f;
		}

		var finalDamage = Mathf.FloorToInt(damage);

		var newHp = Mathf.Max(0f, target.hp - finalDamage);

		target.Rpc(nameof(RpcReceiveDamage), finalDamage, newHp, isCritical);

		return true;
	}

	[Rpc(CallLocal = true)]
	public void RpcReceiveDamage(int damage, uint newHp, bool isCritical) {
		hp = newHp;

		_damageNumberPrefab.Instantiate<CombatNumber>(EffectContainer.instance)
			.Begin(this, damage);

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
		hp = stats.Vitality;
		mp = stats.Intelligence;

		ActorAvatars.instance.Add(this);

		_animator.FadeIn();

		if (!isPlayer) {
			return;
		}

		PlayerController.instance.Begin(this);
		CameraController.instance.Follow(this);
	}

	public void OnDeath() {
		_animator.FadeOut();

		collisionShape.Disabled = true;
		actors.Remove(this);

		ActorAvatars.instance.Remove(this);

		Death?.Invoke();
	}
}