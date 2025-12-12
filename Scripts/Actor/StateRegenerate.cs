using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class StateRegenerate : StateBase {
	[Export]
	public Actor _actor;

	public ActionSetup _actionSetup;

	public override void OnEnter() {
		// OG regen time: 0.520833s, trigger at 50%
		_actor.sprite.AnimationFinished += OnAnimationFinished;
		_actor.sprite.FrameChanged += OnSpriteFrameChanged;
		_actor.sprite.Play("Cast");

		// LocalAudio.Play(_actor.CameraTarget, _castAudio, 0.75f);
	}

	public override void OnExit() {
		_actor.sprite.AnimationFinished -= OnAnimationFinished;
		_actor.sprite.FrameChanged -= OnSpriteFrameChanged;
	}

	public void Regenerate(ActionSetup actionSetup) {
		_actionSetup = actionSetup;

		_actor.stateMachine.TryEnter("Regenerate");
	}

	public void OnSpriteFrameChanged() {
		var currentFrame = _actor.sprite.Frame;
		if (currentFrame != 2) {
			return;
		}

		// @TODO Play effects.

		if (!Multiplayer.IsServer()) {
			return;
		}

		if (_actionSetup.condition == ActionSetup.Conditions.IsHpMissing) {
			var heal = _actor.stats.GetHpRegeneration(_actionSetup.power);
			_actor.Heal(heal, true);

			return;
		}

		var refresh = _actor.stats.GetSpRegeneration(_actionSetup.power);
		_actor.Refresh(refresh, true);
	}

	public void OnAnimationFinished() {
		_actor.stateMachine.TryEnter("Idle");
	}
}