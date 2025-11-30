using Artimus.Services;
using Godot;
using Starbattle.Controllers;

namespace Starbattle;

[GlobalClass]
public partial class Actor : Node3D {
	public static Actor player;

	public bool isPlayer;

	public float angle;

	[Export]
	public ActorSynchronizer synchronizer;

	[Export]
	public CollisionShape3D collisionShape;

	public CapsuleShape3D capsuleShape;

	public float Size => collisionShape.Shape.GetMargin();

	[Export]
	public AnimatedSprite3D sprite;

	[Export]
	public Sprite3D shadow;

	public float Height => sprite.PixelSize * setup.pixelHeight;

	public Vector3 CameraTarget => collisionShape.GlobalPosition;

	public ActorSetup setup;

	[Export]
	public ActorSetups _setups;

	public ActorSetups Setups => _setups;

	[Export]
	public ActorAction action;

	[Export]
	public StateMachine stateMachine;

	public override void _EnterTree() {
		capsuleShape = collisionShape.Shape as CapsuleShape3D;

		// Warning: Synchronizer fields are not set yet!

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

	private void OnCreated(uint actorId) {
		Position = synchronizer.spawnPosition;

		setup = _setups.GetSetup(actorId);
		sprite.SpriteFrames = setup.AnimationFrames;

		GD.Print($"Created with {actorId} / {setup.name} at {synchronizer.spawnPosition} / {Position}");

		var spriteOffset = sprite.PixelSize * setup.SpriteSize / 2f;

		sprite.Position = new Vector3(0, spriteOffset, 0);
		sprite.Play("Idle");

		var height = Height;

		collisionShape.Position = new Vector3(0, height / 2f , 0);
		capsuleShape.Height = height ;
		capsuleShape.Radius = height / 4f; // May require customization for certain actors.
		shadow.Scale = new Vector3(1, 1, 1) * setup.SpriteSize / 35f;

		isPlayer = synchronizer.playerId == Multiplayer.GetUniqueId();
		if (!isPlayer) {
			return;
		}

		player = this;

		PlayerController.instance.Begin(this);
		CameraController.instance.Follow(this);
	}
}