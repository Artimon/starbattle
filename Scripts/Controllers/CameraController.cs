using Godot;

namespace Starbattle;

[GlobalClass]
public partial class CameraController : Node3D {
	public static CameraController instance;

	public Actor _actor;

	[Export]
	public Camera3D camera;

	public float Angle => Rotation.Y;

	public Vector3 _selfieStick;

	public override void _EnterTree() {
		instance = this;

		var angle = Mathf.DegToRad(57f);

		_selfieStick = new Vector3(8f, 3.5f, 0f)
			.Rotated(Vector3.Down, angle);

		var lookAtPosition = GlobalPosition - _selfieStick;

		LookAt(lookAtPosition);

		SetProcess(false);
	}

	public override void _Process(double delta) {
		var anchorPosition = _actor?.CameraTarget ?? Vector3.Zero;
		var targetPosition = anchorPosition + _selfieStick;
		var progress = Mathf.Min(1f, 10f * (float)delta);

		GlobalPosition = GlobalPosition.Lerp(targetPosition, progress);
	}

	public void Follow(Actor actor) {
		_actor = actor;

		GlobalPosition = actor.GlobalPosition + _selfieStick;

		SetProcessMode(ProcessModeEnum.Pausable);
		SetProcess(true);
	}
}