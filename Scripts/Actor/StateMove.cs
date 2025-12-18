using System;
using Artimus.Services;
using Godot;
using Starbattle.Effects;

namespace Starbattle;

[GlobalClass]
public partial class StateMove : StateBase {
	[Export]
	public Actor _actor;

	public Vector3 _startPosition;
	public Vector3 _targetPosition;
	public Vector3 _virtualPosition;

	public float _lerpDuration;
	public float _elapsedTime;

	[Export]
	public AudioStream _moveAudio;

	public Action _onFinished;

	public override void OnEnter() {
		_actor.sprite.Animation = "Move";
		_actor.sprite.Frame = 0;

		_actor.Face(_targetPosition);

		LocalAudio.Play(_actor.GlobalPosition, _moveAudio);
	}

	public override void OnProcess(double deltaTime) {
		// Linear moving virtual point.
		_elapsedTime += (float)deltaTime;

		var virtualProgress = Mathf.Clamp(_elapsedTime / _lerpDuration, 0f, 1f);
		if (virtualProgress >= 1f) {
			_actor.sprite.Frame = 2;
		}

		_virtualPosition = _startPosition.Lerp(_targetPosition, virtualProgress);

		// Linear follow moving point to accelerate/decelerate.
		var moveProgress = Mathf.Min(1f, 8f * (float)deltaTime);

		_actor.GlobalPosition = _actor.GlobalPosition.Lerp(_virtualPosition, moveProgress);

		var distance = (_actor.GlobalPosition - _targetPosition).Length();
		if (distance > 0.1f) {
			return;
		}

		_actor.stateMachine.TryEnter("Idle");
		_onFinished?.Invoke();
	}

	public void MoveTo(Vector3 position, Action onFinished = null) {
		_startPosition = _actor.GlobalPosition;
		_targetPosition = position;

		var distance = _targetPosition - _startPosition;
		var speed = 10f; // @TODO Get from somewhere else, roughly og speed.

		_lerpDuration = distance.Length() / speed;
		_elapsedTime = 0f;

		_onFinished = onFinished;

		_actor.stateMachine.Force("Move");
	}
}