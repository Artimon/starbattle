using System;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorAction : Node {
	[Export]
	public Actor _actor;

	public double _actionTime;

	public double ActionTime => _actionTime;

	public int _lastActionCharges;

	[Export]
	public ActionSetups _actionSetups;

	public ActionSetups ActionSetups => _actionSetups;

	public bool IsIdle => _actor.stateMachine.IsInState("Idle");

	public event Action ActionCharge;

	public override void _EnterTree() {
		SetProcess(false);
	}

	public override void _Process(double delta) {
		if (!IsIdle) {
			return;
		}

		var statsFactor = 1f + _actor.stats.agility / 200f;

		_actionTime += 0.6f * statsFactor * delta; // Take 5 second with 0 agi to reach 3.
		_actionTime = Mathf.Clamp(_actionTime, 0d, 3d);

		var actionCharges = Mathf.FloorToInt(_actionTime);
		if (_lastActionCharges != actionCharges) {
			_lastActionCharges = actionCharges;

			ActionCharge?.Invoke();
		}
	}

	public bool TryRequestAction(string actionName, Actor actor, Vector3 position, bool isCounter = false) {
		var actionSetup = _actionSetups.GetSetup(actionName);

		return TryRequestAction(actionSetup, actor, position, isCounter);
	}

	/**
	 * This time we sanitize on client, cuz who's gonna manipulate this anyway, riiight?
	 */
	public bool TryRequestAction(ActionSetup actionSetup, Actor actor, Vector3 position, bool isCounter = false) {
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

		if (_actor.sp < actionSetup.spCost) {
			return false;
		}

		if (!isCounter) {
			if (_actionTime < actionSetup.actionCost) {
				return false;
			}

			_actionTime -= actionSetup.actionCost;
		}

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

			case ActionSetup.ActionTypes.Special:
				if (actor == null) {
					return;
				}

				targetPosition = actor.GlobalPosition;

				_actor.Drain(action.spCost);

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

			case ActionSetup.ActionTypes.Special:
				PerformMagic(action, actorHandle, position);

				break;
		}
	}

	public void PerformMove(Vector3 position) {
		_actor.stateMachine.Get<StateMove>().MoveTo(position);
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
		var playerPosition = _actor.GlobalPosition;
		var distance = playerPosition.DistanceTo(position);

		if (distance <= 0.35f) {
			_actor.stateMachine
				.Get<StateAttack>()
				.Attack(actionSetup, actor, attackPosition);

			return;
		}

		_actor.stateMachine
			.Get<StateMove>()
			.MoveTo(position, () => {
				_actor.stateMachine
					.Get<StateAttack>()
					.Attack(actionSetup, actor, attackPosition);
			});
	}

	public void PerformRegenerate(ActionSetup actionSetup) {
		_actor.stateMachine
			.Get<StateRegenerate>()
			.Regenerate(actionSetup);
	}

	public void PerformMagic(ActionSetup actionSetup, uint actorHandle, Vector3 position) {
		var actor = Actor.Resolve(actorHandle);
		if (actor == null) {
			return;
		}

		_actor.stateMachine
			.Get<StateCast>()
			.Cast(actionSetup, actor, position);
	}

	public bool TryRequestHit() {
		if (_actor.stateMachine.IsInState("Hit")) {
			return false;
		}

		Rpc(nameof(RpcBeginHit));

		return true;
	}

	[Rpc(CallLocal = true)]
	public void RpcBeginHit() {
		_actor.stateMachine.Force("Hit");
	}

	public bool HasValidActor(ActionSetup actionSetup, Actor actor) {
		if (actor == null) {
			return false;
		}

		var canTarget = actionSetup.CanTarget(_actor, actor);
		if (!canTarget) {
			return false;
		}

		return IsInRange(actor);
	}

	public bool IsInRange(Actor actor) {
		var distance = (_actor.GlobalPosition - actor.GlobalPosition).Length();

		return distance <= _actor.actionRange;
	}

	public Vector3 GetLimitedPosition(Vector3 position) {
		var playerPosition = _actor.GlobalPosition;
		var distance = position - playerPosition;

		if (distance.Length() > _actor.actionRange) {
			position = playerPosition + distance.Normalized() * _actor.actionRange;
		}

		return position;
	}

	public Vector3 GetAttackPosition(Actor actor) {
		var playerPosition = _actor.GlobalPosition;
		var targetPosition = actor.GlobalPosition;

		var direction = (playerPosition - targetPosition).Normalized();

		return targetPosition + direction * 1.5f;
	}
}