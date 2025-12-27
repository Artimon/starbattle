using Artimus.Services;
using Godot;

namespace Starbattle.Controllers;

[GlobalClass]
public partial class CameraController : Node3D {
	public static CameraController instance;

	public Actor _actor;

	[Export]
	public Camera3D camera;

	public readonly FastNoiseLite _noise = new ();

	public float Angle => Rotation.Y;

	public Vector3 _selfieStick;

	public float _trauma;

	public override void _EnterTree() {
		instance = this;

		var angle = Mathf.DegToRad(57f);

		_selfieStick = new Vector3(8f, 3.5f, 0f)
			.Rotated(Vector3.Down, angle);
	}

	public override void _Process(double delta) {
		var anchorPosition = _actor?.CameraTarget ?? Vector3.Zero;
		var targetPosition = anchorPosition + _selfieStick;
		var progress = Mathf.Min(1f, 10f * (float)delta);

		GlobalPosition = GlobalPosition.Lerp(targetPosition, progress);

		var lookAtPosition = GlobalPosition - _selfieStick;
		LookAt(lookAtPosition);

		ApplyTrauma(delta);
	}

	public void Follow(Actor actor) {
		_actor = actor;

		GlobalPosition = actor.GlobalPosition + _selfieStick;
	}

	/**
	 * Around 0.35f should be the minimum trauma to have a noticeable effect.
	 *
	 * @see https://youtu.be/tu-Qe66AvtY?si=KhNE_EEt6Ow49-wI&t=889
	 */
	public void AddTrauma(float trauma) {
		_trauma = Mathf.Min(_trauma + trauma, 1f);
	}

	public void ApplyTrauma(double delta) {
		_trauma -= (float)delta * 0.65f;
		if (_trauma <= 0f) {
			_trauma = 0f;

			return;
		}

		var shake = _trauma * _trauma;
		var time = GlobalTime.Seconds;

		var offset = Mathf.Sin(16f * time * Mathf.Pi) * shake * 0.025f;
		GlobalPosition += new Vector3(0f, offset, 0f);

		var angles = new Vector3 {
			X = _noise.GetNoise1D(time) * shake * 1f,
			Y = _noise.GetNoise1D(time + 60f) * shake * 1f,
			Z = _noise.GetNoise1D(time + 120f) * shake * 2f
		};

		// var offset = new Vector3 {
		// 	X = _noise.GetNoise1D(5f * time + 180) * shake * 0.05f,
		// 	Y = _noise.GetNoise1D(5f * time + 240) * shake * 0.05f,
		// 	Z = _noise.GetNoise1D(5f * time + 300) * shake * 0.05f
		// };

		RotationDegrees += angles;
		// GlobalPosition += offset;
	}
}