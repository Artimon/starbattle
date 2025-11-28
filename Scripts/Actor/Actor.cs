using Godot;
using Starbattle.Controllers;

namespace Starbattle;

[GlobalClass]
public partial class Actor : Node3D {
	public static Actor player;

	public bool isPlayer;

	[Export]
	public ActorSynchronizer synchronizer;

	[Export]
	public CollisionShape3D collisionShape;

	public CapsuleShape3D capsuleShape;

	public float Size => collisionShape.Shape.GetMargin();

	[Export]
	public AnimatedSprite3D sprite;

	public float Height => sprite.PixelSize * setup.pixelHeight;

	public ActorSetup setup;

	[Export]
	public ActorSetups _setups;

	public ActorSetups Setups => _setups;

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

		isPlayer = synchronizer.playerId == Multiplayer.GetUniqueId();
		if (!isPlayer) {
			return;
		}

		player = this;

		PlayerController.instance.Begin(this);
		ControllerCamera.instance.Follow(this);
	}
}