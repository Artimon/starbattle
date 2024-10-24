using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ControllerCamera : Node3D {
	public static ControllerCamera instance;

	public Actor _actor;
	public Camera3D _camera;

	public Vector3 _selfieStick;

	public override void _EnterTree() {
		instance = this;

		var angle = Mathf.DegToRad(57f);

		_selfieStick = new Vector3(6f, 2f, 0f)
			.Rotated(Vector3.Down, angle);

		var lookAtPosition = GlobalPosition - _selfieStick;

		LookAt(lookAtPosition);

		SetProcess(false);
	}

	public override void _Process(double delta) {
		var targetPosition = _actor.cameraTarget.GlobalPosition + _selfieStick;
		var progress = Mathf.Min(1f, 10f * (float)delta);

		GlobalPosition = GlobalPosition.Lerp(targetPosition, progress);
	}

	public void Follow(Actor actor) {
		_actor = actor;

		GlobalPosition = actor.cameraTarget.GlobalPosition + _selfieStick;

		SetProcessMode(ProcessModeEnum.Pausable);
		SetProcess(true);
	}
}