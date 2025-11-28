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

	public float Size => collisionShape.Shape.GetMargin();

	[Export]
	public AnimatedSprite3D sprite;

	public ActorSetup setup;

	[Export]
	public ActorSetups _setups;

	public ActorSetups Setups => _setups;

	public override void _EnterTree() {
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

		var offset = sprite.PixelSize * setup.SpriteSize / 2f;

		sprite.Position = new Vector3(0, offset, 0);
		sprite.Play("Idle");

		isPlayer = synchronizer.playerId == Multiplayer.GetUniqueId();
		if (!isPlayer) {
			return;
		}

		player = this;

		PlayerController.instance.Begin(this);
		ControllerCamera.instance.Follow(this);
	}
}