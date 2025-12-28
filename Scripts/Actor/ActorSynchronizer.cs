using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorSynchronizer : MultiplayerSynchronizer {
	[Export]
	public Actor _actor;

	[Export]
	public uint handle; // Network-wide unique identifier.

	[Export]
	public int playerId;

	[Export]
	public uint actorId;

	[Export]
	public Vector3 spawnPosition;

	[Export]
	public float vitality;

	// @TODO Add all stats here and re-route access from actor.stats?

	public override void _Process(double delta) {
		// _actor.stats.vitality = vitality;
	}
}