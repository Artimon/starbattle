using Godot;

namespace Starbattle;

[GlobalClass]
public partial class CombatNumber : Node3D {
	[Export]
	public Label3D _label;

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

		_label.Position = position;
	}

	public void Begin(Actor actor, int number) {
		var position = actor.GlobalCenter + Vector3.Up * 0.25f * actor.Height;
		position.X += GD.Randf() * 1f - 0.5f;
		position.Y += GD.Randf() * 1f - 0.5f;
		position.Z += GD.Randf() * 1f - 0.5f;

		GlobalPosition = position;

		_label.Text = number.ToString();
		_speed = 1f + GD.Randf() * 0.2f;

		SetProcess(true);
	}
}