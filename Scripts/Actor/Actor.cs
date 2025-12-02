using System.Collections.Generic;
using Artimus.Services;
using Godot;
using Starbattle.Controllers;

namespace Starbattle;

[GlobalClass]
public partial class Actor : Node3D {
	public static readonly List<Actor> actors = new (16);

	public bool isPlayer;

	public bool IsPlayerGroup => synchronizer.playerId != 0;

	public float angle;

	public float actionRange = 6f;

	[Export]
	public ActorSynchronizer synchronizer;

	[Export]
	public CollisionShape3D collisionShape;

	public CapsuleShape3D capsuleShape;

	[Export]
	public AnimatedSprite3D sprite;

	[Export]
	public Sprite3D shadow;

	public float Height => sprite.PixelSize * setup.pixelHeight;

	public Vector3 CameraTarget => collisionShape.GlobalPosition;

	public float SpriteSize => setup.SpritePixels * sprite.PixelSize;

	public ActorSetup setup;

	[Export]
	public ActorSetups _setups;

	public ActorSetups Setups => _setups;

	[Export]
	public ActorAction action;

	[Export]
	public StateMachine stateMachine;

	public override void _EnterTree() {
		actors.Add(this);

		capsuleShape = collisionShape.Shape as CapsuleShape3D;

		// Warning: Synchronizer fields are not set yet!

		// Does not get called on the server!
		synchronizer.DeltaSynchronized += () => {
			GD.Print($"Actor (delta) synchronized: {synchronizer.handle} / {synchronizer.playerId} ({Multiplayer.GetUniqueId()})");
		};
	}

	public override void _Ready() {
		OnCreated(synchronizer.actorId);
		// GD.Print($"My network handle: {synchronizer.handle} / {synchronizer.ownerId} ({Multiplayer.GetUniqueId()})");
	}

	// public override void _Process(double delta) {
	// 	GD.Print($"ActorID on {Multiplayer.GetUniqueId()}: {synchronizer.actorId}");
	// }

	public void ApplyAngle() {
		var cameraAngle = CameraController.instance.Angle;
		var angleToCamera = angle - cameraAngle;

		sprite.FlipH = Mathf.Sin(angleToCamera) > 0f;
	}

	public static Actor Resolve(uint handle) => actors.Find(actor => actor.synchronizer.handle == handle);

	private void OnCreated(uint actorId) {
		Position = synchronizer.spawnPosition;

		setup = _setups.GetSetup(actorId);
		sprite.SpriteFrames = setup.AnimationFrames;

		GD.Print($"Created with {actorId} / {setup.name} at {synchronizer.spawnPosition} / {Position}");

		var spriteOffset = sprite.PixelSize * setup.SpritePixels / 2f;

		sprite.Position = new Vector3(0, spriteOffset, 0);
		sprite.Play("Idle");

		var height = Height;

		collisionShape.Position = new Vector3(0, height / 2f , 0);
		capsuleShape.Height = height ;
		capsuleShape.Radius = height / 4f; // May require customization for certain actors.
		shadow.Scale = new Vector3(1, 1, 1) * setup.SpritePixels / 35f;

		isPlayer = synchronizer.playerId == Multiplayer.GetUniqueId();
		if (!isPlayer) {
			return;
		}

		PlayerController.instance.Begin(this);
		CameraController.instance.Follow(this);
	}

	public override void _ExitTree() {
		actors.Remove(this);
	}
}