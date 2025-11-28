using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorSynchronizer : MultiplayerSynchronizer {
	[Export]
	public long handle; // Network-wide unique identifier.

	[Export]
	public long ownerId;

	[Export]
	public uint actorId;
}