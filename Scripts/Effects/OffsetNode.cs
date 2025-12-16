using Godot;

namespace Starbattle.Effects;

[GlobalClass]
public partial class OffsetNode : Node3D {
	[Export]
	public Node3D _node;

	[Export]
	public float _offsetDistance = 0.3f;

	public Camera3D _camera;

	public override void _Ready() {
		_camera = GetViewport().GetCamera3D();
	}

	public override void _Process(double delta) {
		var direction = (_camera.GlobalTransform.Origin - GlobalTransform.Origin).Normalized();

		_node.GlobalTransform = new Transform3D(
			_node.GlobalTransform.Basis,
			GlobalTransform.Origin + direction * _offsetDistance
		);
	}
}