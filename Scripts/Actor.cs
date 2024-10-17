using Godot;

namespace Starbattle;

[GlobalClass]
public partial class Actor : Node3D {
	public string displayName;

	public int prefabIndex;

	public long ownerId;

	[Rpc(MultiplayerApi.RpcMode.AnyPeer)]
	public void SayHello() {
		GD.Print("Hello, I am " + displayName);
	}

	[Rpc]
	public void SetPosition(Vector3 position) {
		GlobalPosition = position;
	}
}