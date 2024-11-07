using System;
using Godot;

namespace Starbattle;

public partial class NetworkNode3D : Node3D {
	public long uniqueId;
	public long ownerId;
	public int prefabIndex;

	public event Action<NetworkNode3D> OnExitTree;

	public override void _ExitTree() {
		OnExitTree?.Invoke(this);
	}
}