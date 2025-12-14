using Godot;
using Starbattle.Controllers;

namespace Starbattle;

[GlobalClass]
public partial class CombatMessage : Node3D {
	public enum Types {
		Critical,
		Counter,
		Miss
	}

	[Export]
	public Sprite3D _sprite;

	[Export]
	public Texture2D _criticalTexture;

	[Export]
	public Texture2D _counterTexture;

	[Export]
	public Texture2D _missTexture;

	public float _timer;
	public float _speed;

	public override void _EnterTree() {
		SetProcess(false);
	}

	public override void _Process(double delta) {
		_timer += (float)delta;
		if (_timer > 1.5f) {
			this.Remove();

			return;
		}

		LookAt(CameraController.instance.camera.GlobalPosition);

		var position = Vector3.Zero;
		position.X = -0.25f * _timer * _speed;
		position.Y = 1f * Mathf.Sin(0.5f * _timer * Mathf.Pi) * _speed;

		_sprite.Position = position;
	}

	public void ShowMessage(Actor actor, Types type) {
		_speed = 1f + GD.Randf() * 0.2f;

		GlobalPosition = actor.GlobalCenter + Vector3.Up * 0.5f * actor.Height;

		_sprite.Texture = type switch {
			Types.Critical => _criticalTexture,
			Types.Counter => _counterTexture,
			Types.Miss => _missTexture,
			_ => _sprite.Texture
		};

		SetProcess(true);
	}
}
