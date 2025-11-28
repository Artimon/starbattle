using Godot;

namespace Starbattle;

[GlobalClass]
public partial class Actor : Node3D {
	[Export]
	public ActorSynchronizer synchronizer;

	[Export]
	public AnimatedSprite3D sprite;

	[Export]
	public ActorSetups _setups;

	public ActorSetup setup;

	public override void _EnterTree() {
		// Warning: Synchronizer fields are not set yet!

		synchronizer.DeltaSynchronized += () => {
			GD.Print($"Actor synchronized: {synchronizer.handle} / {synchronizer.ownerId} ({Multiplayer.GetUniqueId()})");

			OnCreated(synchronizer.actorId);
		};
	}

	public override void _Ready() {
		GD.Print($"My network handle: {synchronizer.handle} / {synchronizer.ownerId} ({Multiplayer.GetUniqueId()})");
	}

	private void OnCreated(uint actorId) {
		setup = _setups.GetSetupById(actorId);
		sprite.SpriteFrames = setup.AnimationFrames;

		var spriteSize = setup.SpriteSize;

		sprite.Scale = new Vector3(spriteSize, spriteSize, 1);
		sprite.Position = new Vector3(0, spriteSize / 2, 0);
	}
}