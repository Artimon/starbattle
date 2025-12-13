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

		if (_actionSetup.condition == ActionSetup.Conditions.IsHpMissing) {
			_Heal();
			_PlayEffect();

			return;
		}

		_Refresh();
		_PlayEffect();
	}

	public void _Heal() {
		if (Multiplayer.IsServer()) {
			var heal = _actor.stats.GetHpRegeneration(_actionSetup.power);
			_actor.Heal(heal, true);
		}
	}

	public void _Refresh() {
		if (Multiplayer.IsServer()) {
			var refresh = _actor.stats.GetSpRegeneration(_actionSetup.power);
			_actor.Refresh(refresh, true);
		}
	}

	public void _PlayEffect() {
		var effect = EffectContainer.instance.Instantiate<Node3D>(_actionSetup.pointPrefab, _actor.GlobalPosition);
		effect.Scale = Vector3.One * _actor.EffectScale;
	}

	public void OnAnimationFinished() {
		_actor.stateMachine.TryEnter("Idle");
	}
}