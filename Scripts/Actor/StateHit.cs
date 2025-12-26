using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class StateHit : StateBase {
	[Export]
	public Actor _actor;

	public double _duration;

	public override void OnEnter() {
		_actor.sprite.Animation = "Hit";
		_actor.sprite.Frame = 0;

		_duration = 0.5625f;
	}

	public override void OnProcess(double deltaTime) {
		_duration -= deltaTime;

		var progress = 5.5f * GlobalTime.Seconds;

		_actor.sprite.Position += new Vector3(
			Mathf.Cos(progress * 5f) * (float)deltaTime,
			Mathf.Sin(progress * 2f) * (float)deltaTime,
			Mathf.Cos(progress * 5f) * (float)deltaTime
		);

		if (_duration > 0d) {
			return;
		}

		_actor.stateMachine.Force("Idle");
	}

	public override void OnExit() {
		_actor.sprite.Position = Vector3.Zero;
	}
}