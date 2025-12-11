using Godot;
using TargetTypes = Starbattle.ActionSetup.TargetTypes;

namespace Starbattle;

[GlobalClass]
public partial class ActorAction : Node {
	[Export]
	public Actor _player;

	public double _actionTime;

	public double ActionTime => _actionTime;

	[Export]
	public ActionSetups _actionSetups;

	public bool IsIdle => _player.stateMachine.IsInState("Idle");

	public override void _EnterTree() {
		SetProcess(false);
	}

	public override void _Process(double delta) {
		if (!IsIdle) {
			return;
		}

		var statsFactor = 1f + _player.stats.agility / 200f;

		_actionTime += 0.6f * statsFactor * delta; // Take 5 second with 0 agi to reach 3.
		_actionTime = Mathf.Clamp(_actionTime, 0d, 3d);
	}

	/**
	 * This time we sanitize on client, cuz who's gonna manipulate this anyway, riiight?
	 */
	public bool TryRequestAction(ActionSetup actionSetup, Actor actor, Vector3 position) {
		if (actionSetup == null) {
			return false;
		}

		if (!IsIdle) {
			return false;
		}

		if (
			actionSetup.TargetsActor &&
			!HasValidActor(actionSetup, actor)
		) {
			return false;
		}

		if (!actionSetup.MeetsCondition(actor)) {
			return false;
		}

		if (_actionTime < actionSetup.actionCost) {
			return false;
		}

		_actionTime -= actionSetup.actionCost;

		var actorHandle = actor?.synchronizer.handle ?? 0;

		RpcId(1, nameof(_RpcRequestAction), actionSetup.ActionId, actorHandle, position);

		return true;
	}

	/**
	 * Important:
	 * During initialization of the network, not all clients may know the other peers, yet.
	 * Hence, only requesting the server is reliable, since the server MUST know all peers.
	 */
	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
	public void _RpcRequestAction(uint actionId, uint actorHandle, Vector3 position) {
		if (!Multiplayer.IsServer()) {
			return;
		}

		if (!IsIdle) {
			// Maybe communicate back to re-open the action menu? Or timeout on client.
			return;
		}

		var targetPosition = position;
		var action = _actionSetups.GetSetup(actionId);
		var actor = Actor.Resolve(actorHandle);

		switch (action.actionType) {
			case ActionSetup.ActionTypes.Move:
				targetPosition = GetLimitedPosition(position);

				break;

			case ActionSetup.ActionTypes.Attack:
				if (actor == null) {
					return;
				}

				targetPosition = GetAttackPosition(actor);

				break;

			case ActionSetup.ActionTypes.Regenerate:
				break;

			case ActionSetup.ActionTypes.Magic:
				if (actor == null) {
					return;
				}

				targetPosition = actor.GlobalPosition;

				break;
		}

		Rpc(nameof(RpcBeginAction), actionId, actorHandle, targetPosition);
	}

	[Rpc(CallLocal = true)]
	public void RpcBeginAction(uint actionId, uint actorHandle, Vector3 position) {
		var action = _actionSetups.GetSetup(actionId);

		switch (action.actionType) {
			case ActionSetup.ActionTypes.Move:
				PerformMove(position);

				break;

			case ActionSetup.ActionTypes.Attack:
				PerformAttack(action, actorHandle, position);

				break;

			case ActionSetup.ActionTypes.Regenerate:
				PerformRegenerate(action);

				break;

			case ActionSetup.ActionTypes.Magic:
				PerformMagic(action, actorHandle, position);

				break;
		}
	}

	public void PerformMove(Vector3 position) {
		_player.stateMachine.Get<StateMove>().MoveTo(position);
	}

	/**
	 * Clients are allowed to decide if they need to move or not, just like in the original game.
	 */
	public void PerformAttack(ActionSetup actionSetup, uint actorHandle, Vector3 position) {
		var actor = Actor.Resolve(actorHandle);
		if (actor == null) {
			return; // Not synchronized or already removed.
		}

		var attackPosition = actor.GlobalPosition;
		var playerPosition = _player.GlobalPosition;
		var distance = playerPosition.DistanceTo(position);

		if (distance <= 0.35f) {
			_player.stateMachine
				.Get<StateAttack>()
				.Attack(actionSetup, actor, attackPosition);

			return;
		}

		_player.stateMachine
			.Get<StateMove>()
			.MoveTo(position, () => {
				_player.stateMachine
					.Get<StateAttack>()
					.Attack(actionSetup, actor, attackPosition);
			});
	}

	public void PerformRegenerate(ActionSetup actionSetup) {
		_player.stateMachine
			.Get<StateRegenerate>()
			.Regenerate(actionSetup);
	}

	public void PerformMagic(ActionSetup actionSetup, uint actorHandle, Vector3 position) {
		var actor = Actor.Resolve(actorHandle);
		if (actor == null) {
			return;
		}

		_player.stateMachine
			.Get<StateCast>()
			.Cast(actionSetup, actor, position);
	}

	public bool HasValidActor(ActionSetup actionSetup, Actor actor) {
		if (actor == null) {
			return false;
		}

		var canTarget = actionSetup.CanTarget(_player, actor);
		if (!canTarget) {
			return false;
		}

		return IsInRange(actor);
	}

	public bool IsInRange(Actor actor) {
		var distance = (_player.GlobalPosition - actor.GlobalPosition).Length();

		return distance <= _player.actionRange;
	}

	public Vector3 GetLimitedPosition(Vector3 position) {
		var playerPosition = _player.GlobalPosition;
		var distance = position - playerPosition;

		if (distance.Length() > _player.actionRange) {
			position = playerPosition + distance.Normalized() * _player.actionRange;
		}

		return position;
	}

	public Vector3 GetAttackPosition(Actor actor) {
		var playerPosition = _player.GlobalPosition;
		var targetPosition = actor.GlobalPosition;

		var direction = (playerPosition - targetPosition).Normalized();

		return targetPosition + direction * 1.5f;
	}
}