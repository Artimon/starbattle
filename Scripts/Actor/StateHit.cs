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
		if (_duration > 0d) {
			return;
		}

		// @TODO Check for counter attack.
		_actor.stateMachine.TryEnter("Idle");
	}
}