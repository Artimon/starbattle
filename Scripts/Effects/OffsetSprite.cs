using Godot;

namespace Starbattle.Effects;

[GlobalClass]
public partial class OffsetSprite : Node3D {
	[Export]
	public Sprite3D _sprite;

	[Export]
	public float _offsetDistance = 0.3f;

	public Camera3D _camera;

	public float Alpha {
		get => _sprite.Modulate.A;
		set => _sprite.Modulate = new Color(1f, 1f, 1f, value);
	}

	public override void _Ready() {
		_camera = GetViewport().GetCamera3D();
	}

	public override void _Process(double delta) {
		var direction = (_camera.GlobalTransform.Origin - GlobalTransform.Origin).Normalized();

		_sprite.GlobalTransform = new Transform3D(
			_sprite.GlobalTransform.Basis,
			GlobalTransform.Origin + direction * _offsetDistance
		);
	}
}