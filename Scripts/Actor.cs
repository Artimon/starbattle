using Godot;

namespace Starbattle;

[GlobalClass]
public partial class Actor : Node3D {
	public string displayName;

	public int prefabIndex;

	public long ownerId;

	public float inputX;

	public bool IsPlayer => ownerId == Multiplayer.GetUniqueId();

	public override void _Process(double delta) {
		var velocity = new Vector3(inputX, 0f, 0f) * (float)delta;

		GlobalPosition += velocity;
	}

	[Rpc(MultiplayerApi.RpcMode.AnyPeer)]
	public void _SetInput(float value) {
		inputX = value;
	}

	public override void _Input(InputEvent @event) {
		if (!IsPlayer) {
			return;
		}

		inputX = Input.GetAxis("Left", "Right");

		Rpc(nameof(_SetInput), inputX);
	}
}