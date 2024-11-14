using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ServerSynchronizer : MultiplayerSynchronizer {
	[Export]
	public long networkHandle;

	[Export]
	public long ownerId;
}