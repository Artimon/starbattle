using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class StateAttack : StateBase {
	[Export]
	public ActorBase _actor;

	public override string StateName => "Attack";

	public void Attack(ActorBase target) {
		var canEnterState = _actor.stateMachine.CanEnter("Attack");
		if (!canEnterState) {
			return;
		}

		GD.Print($"My size vs target size: {_actor.Size} vs {target.Size}");
		// @TODO Implement attack logic.

		_actor.stateMachine.Force("Attack");
	}
}