using System.Collections.Generic;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorMob : ActorBase {
	public static readonly List<ActorMob> mobs = new();


	public override void _EnterTree() {
		// Warning: Synchronizer fields are not set yet!

		serverSynchronizer.DeltaSynchronized += () => {
			// GD.Print($"DeltaSynchronized: {serverSynchronizer.networkHandle} / {serverSynchronizer.ownerId} ({Multiplayer.GetUniqueId()})");
		};
	}

	public override void _Ready() {
		// Note: Synchronizer fields are set now!

		mobs.Add(this); // Add here, to ensure all synchronizer fields are set.
	}

	public override void _ExitTree() {
		mobs.Remove(this); // @TODO Also remove onDeath to prevent iteration of dead mobs.
	}
}