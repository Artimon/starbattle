using Godot;

namespace Starbattle;

public struct ActionRequest {
	public int actionId;
	public long actorNetworkHandle;
	public Vector3 position;
}