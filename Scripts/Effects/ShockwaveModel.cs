using Godot;

namespace Starbattle.Effects;

[GlobalClass]
public partial class ShockwaveModel : Node3D {
	[Export]
	public bool _autoStart = true;

	[Export]
	public float _duration = 1.0f;

	[Export]
	public float _minScale = 1.0f;

	[Export]
	public float _maxScale = 2.5f;

	[Export]
	public MeshInstance3D _model;

	public StandardMaterial3D _material;

	public float _time;
	public bool _stopping;

	public override void _Ready() {
		if (_autoStart) {
			Start();

			return;
		}

		SetProcess(false);

		_model.Visible = false;
		_material = _model.GetActiveMaterial(0) as StandardMaterial3D;
	}

	public override void _Process(double delta) {
		_time += (float)delta;
		var progress = _time / _duration;
		if (progress > 1.0f) {
			if (_stopping) {
				this.Remove();

				return;
			}

			progress = 0.0f;
			_time = 0.0f;

			var rotation = _model.RotationDegrees;
			rotation.Y = 360f * GD.Randf();
			_model.RotationDegrees = rotation;
		}

		var scale = Mathf.Lerp(_minScale, _maxScale, progress);
		Scale = new Vector3(scale, scale, scale);

		var color = _material.AlbedoColor;
		var alpha = Mathf.Sin(progress * Mathf.Pi);

		_material.AlbedoColor = new Color(color.R, color.G, color.B, alpha);
	}

	public void Start(float phaseOffset = 0f) {
		_time = phaseOffset * _duration;
		_stopping = false;
		_model.Visible = true;

		SetProcess(true);
	}

	public void Stop() {
		_stopping = true;
	}
}
