using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class StateAttack : StateBase {
	[Export]
	public Actor _actor;

	public Actor _target;

	public override string StateName => "Attack";

	public override void OnEnter() {
		_actor.sprite.Connect("animation_finished", Callable.From(OnAnimationFinished));

		_actor.sprite.SpriteFrames.SetAnimationSpeed("Attack", 8d);
		_actor.sprite.Play("Attack");
	}

	public override void OnExit() {
		_actor.sprite.Disconnect("animation_finished", Callable.From(OnAnimationFinished));
	}

	public void Attack(Actor target) {
		_target = target;
		_actor.stateMachine.TryEnter("Attack");
	}

	public void OnAnimationFinished() {
		if (Multiplayer.IsServer()) {
			GD.Print("Do damage"); // @TODO
		}

		_actor.stateMachine.TryEnter("Idle");
	}
}