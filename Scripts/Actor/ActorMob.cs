using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorMob : ActorBase {
	public override void _EnterTree() {
		// Warning: Synchronizer fields are not set yet!

		serverSynchronizer.DeltaSynchronized += () => {
			// GD.Print($"DeltaSynchronized: {serverSynchronizer.networkHandle} / {serverSynchronizer.ownerId} ({Multiplayer.GetUniqueId()})");
		};
	}

	public override void _Ready() {
		// Note: Synchronizer fields are set now!

		// Add here, to ensure all synchronizer fields are set.
		ActorContainer.instance.Add(this);
	}

	public override void _ExitTree() {
		ActorContainer.instance.Remove(this); // @TODO Also remove onDeath to prevent iteration of dead mobs.
	}
}