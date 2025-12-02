using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class StateAttack : StateBase {
	[Export]
	public Actor _actor;

	public Actor _target;

	public Vector3 _attackPosition;

	public override void OnEnter() {
		_actor.sprite.Connect("animation_finished", Callable.From(OnAnimationFinished));

		_actor.sprite.SpriteFrames.SetAnimationSpeed("Attack", 8d);
		_actor.sprite.Play("Attack");

		_actor.Face(_target);
	}

	public override void OnExit() {
		_actor.sprite.Disconnect("animation_finished", Callable.From(OnAnimationFinished));
	}

	/**
	 * The attackPosition is supposed to be the position when beginning the entire action.
	 * Otherwise, evading would not work, since we'd just apply the damage to the target,
	 * independent of their changed position.
	 */
	public void Attack(Actor target, Vector3 attackPosition) {
		_target = target;
		_attackPosition = attackPosition;

		_actor.stateMachine.TryEnter("Attack");
	}

	public void OnAnimationFinished() {
		_actor.TryAttackArea(_target, _attackPosition);
		_actor.stateMachine.TryEnter("Idle");
	}
}