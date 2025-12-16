using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorBehaviour : Node {
	[Export]
	public Actor _actor;

	[Export]
	public Timer _timer;

	public void Register() {
		if (Multiplayer.IsServer()) {
			_actor.action.ActionCharge += () => {
				TryNextEnemyAction();
			};
		}
	}

	public bool TryCounter() {
		var target = _actor.counterTarget;
		if (target == null || target.IsDead) {
			return false;
		}

		_actor.counterTarget = null;

		var success = _actor.action.TryRequestAction("Attack", target, target.GlobalPosition, true);
		if (success) {
			_actor.Message(CombatMessage.Types.Counter);
		}

		return success;
	}

	public bool TryNextEnemyAction() {
		if (_actor.IsPlayerGroup) {
			return false; // Internal check allows charm actions to work.
		}

		if (_actor.setup == null) {
			return false; // During initialization.
		}

		var performsAction = _actor.setup.defaultBehaviour.TryNextAction(_actor);
		if (!performsAction) {
			GD.Print($"No action selected, implement re-try in 1.5s.");
		}

		return performsAction;
	}
}