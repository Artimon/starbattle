using Godot;

namespace Starbattle.Effects;

[GlobalClass]
public partial class Shockwave : Node3D {
	[Export]
	public bool _autoStart = true;

	[Export]
	public float _duration = 1.0f;

	[Export]
	public float _minScale = 1.0f;

	[Export]
	public float _maxScale = 2.5f;

	[Export]
	public Sprite3D _sprite;

	public float _time;
	public bool _stopping;
	public bool _running;

	public override void _Ready() {
		if (_autoStart) {
			Start();

			return;
		}

		_sprite.Visible = false;
	}

	public override void _Process(double delta) {
		if (!_running) {
			return;
		}

		_time += (float)delta;
		var progress = _time / _duration;
		if (progress > 1.0f) {
			if (_stopping) {
				this.Remove();

				return;
			}

			progress = 0.0f;
			_time = 0.0f;

			var rotation = _sprite.RotationDegrees;
			rotation.Y = 360f * GD.Randf();
			_sprite.RotationDegrees = rotation;
		}

		var scale = Mathf.Lerp(_minScale, _maxScale, progress);

		_sprite.Scale = new Vector3(scale, scale, scale);

		var modulate = _sprite.Modulate;
		var alpha = Mathf.Sin(progress * Mathf.Pi);

		_sprite.Modulate = new Color(modulate.R, modulate.G, modulate.B, alpha);
	}

	public void Start(float phaseOffset = 0f) {
		_time = phaseOffset * _duration;

		_running = true;
		_stopping = false;

		_sprite.Visible = true;

		SetProcess(true);
	}

	public void Stop() {
		_stopping = true;
	}
}