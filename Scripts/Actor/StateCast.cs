using Artimus.Services;
using Godot;
using Starbattle.Effects;
using Starbattle.Spells;

namespace Starbattle;

[GlobalClass]
public partial class StateCast : StateBase {
	[Export]
	public Actor _actor;

	[Export]
	public AudioStream _castAudio;

	public ActionSetup _actionSetup;
	public Actor _target;
	public Vector3 _spellPosition;

	public override void OnEnter() {
		// OG cast time: 0.78125s
		_actor.sprite.AnimationFinished += OnAnimationFinished;
		_actor.sprite.Play("Cast");

		_actor.Face(_target);

		LocalAudio.Play(_actor.CameraTarget, _castAudio, 0.75f);
	}

	public override void OnExit() {
		_actor.sprite.AnimationFinished -= OnAnimationFinished;
	}

	public void Cast(ActionSetup actionSetup, Actor target, Vector3 castPosition) {
		_actionSetup = actionSetup;
		_target = target;
		_spellPosition = castPosition;

		_actor.stateMachine.Force("Cast");
	}

	public void OnAnimationFinished() {
		var liveSpellPosition = _actionSetup.GetPosition(_target, _spellPosition);

		EffectContainer.instance.Instantiate<AoeNode>(_actionSetup.aoePrefab, liveSpellPosition).Initialize(_actionSetup, _actor);

		_actor.stateMachine.TryEnter("Idle");
	}
}