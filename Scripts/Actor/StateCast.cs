using Artimus.Services;
using Godot;
using Starbattle.Spells;

namespace Starbattle;

[GlobalClass]
public partial class StateCast : StateBase {
	[Export]
	public Actor _actor;

	public ActionSetup _actionSetup;
	public Actor _target;
	public Vector3 _spellPosition;

	public override void OnEnter() {
		_actor.sprite.Connect("animation_finished", Callable.From(OnAnimationFinished));
		_actor.sprite.Play("Cast");

		_actor.Face(_target);
	}

	public override void OnExit() {
		_actor.sprite.Disconnect("animation_finished", Callable.From(OnAnimationFinished));
	}

	public void Cast(ActionSetup actionSetup, Actor target, Vector3 castPosition) {
		_actionSetup = actionSetup;
		_target = target;
		_spellPosition = castPosition;

		_actor.stateMachine.TryEnter("Cast");
	}

	public void OnAnimationFinished() {
		EffectContainer.instance.Instantiate<AoeNode>(_actionSetup.aoePrefab, _spellPosition).Initialize(_actionSetup, _actor);

		_actor.stateMachine.TryEnter("Idle");
	}
}