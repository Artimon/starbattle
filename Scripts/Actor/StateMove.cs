using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class StateMove : StateBase {
	[Export]
	public Actor _actor;

	public override string StateName => "Move";

	public Vector3 _startPosition;
	public Vector3 _targetPosition;
	public Vector3 _remainingDistance;

	public float _lerpTime;
	private float _elapsedTime;

	public override void OnProcess(double deltaTime) {
		// _elapsedTime += (float)deltaTime;
		//
		// var progress = Mathf.Clamp(_elapsedTime / _lerpTime, 0f, 1f);
		//
		// _actor.GlobalPosition = _startPosition.Lerp(_targetPosition, progress);
		// // @TODO Add "movement target" object and follow it just like the camera.
		//
		// if (progress < 1f) {
		// 	return;
		// }
		//
		// _actor.stateMachine.TryEnter("Idle");
	}

	public void MoveTo(Vector3 position) {
		// var canEnterState = _actor.stateMachine.CanEnter("Move");
		// if (!canEnterState) {
		// 	return;
		// }
		//
		// _startPosition = _actor.GlobalPosition;
		// _targetPosition = position;
		// _remainingDistance = _targetPosition - _startPosition;
		//
		// _lerpTime = _remainingDistance.Length() / 4f;
		// _elapsedTime = 0f;
		//
		// _actor.stateMachine.Force("Move");
	}
}