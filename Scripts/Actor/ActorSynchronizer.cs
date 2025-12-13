using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorSynchronizer : MultiplayerSynchronizer {
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
}