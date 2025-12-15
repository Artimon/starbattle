using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class StateIdle : StateBase {
	[Export]
	public Actor _actor;

	public override void OnEnter() {
		_actor.sprite.Animation = "Idle";
		_actor.sprite.Frame = 0;

		var target = _actor.counterTarget;
		if (target == null) {
			return;
		}

		_actor.counterTarget = null;

		var actionSetup = _actor.action.ActionSetups.GetSetup("Attack");
		var success = _actor.action.TryRequestAction(actionSetup, target, target.GlobalPosition, true);
		if (success) {
			_actor.Message(CombatMessage.Types.Counter);
		}
	}
}