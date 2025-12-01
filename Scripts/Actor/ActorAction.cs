using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorAction : Node {
	[Export]
	public Actor _player;

	[Export]
	public ActionSetups _actionSetups;

	public bool _isPerformingAction;

	/**
	 * This time we sanitize on client, cuz who's gonna manipulate this anyway, riiight?
	 */
	public bool TryRequestAction(ActionSetup actionSetup, Actor actor, Vector3 position) {
		var hasValidActor = HasValidActor(actionSetup, actor);
		if (!hasValidActor) {
			return false;
		}

		var actorHandle = actor?.synchronizer.handle ?? 0;
		var limitedPosition = GetLimitedPosition(position); // Can always be done.

		RpcId(1, nameof(_RpcRequestAction), actionSetup.ActionId, actorHandle, limitedPosition);

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

		if (_isPerformingAction) {
			// Maybe communicate back to re-open the action menu? Or timeout on client.
			return;
		}

		Rpc(nameof(RpcBeginAction), actionId, actorHandle, position);
	}

	[Rpc(CallLocal = true)]
	public void RpcBeginAction(uint actionId, uint actorHandle, Vector3 position) {
		var action = _actionSetups.GetSetup(actionId);

		switch (action.actionType) {
			case ActionSetup.ActionTypes.Move:
				PerformMove(position);

				break;

			case ActionSetup.ActionTypes.Attack:
				break;
		}
	}

	public void PerformMove(Vector3 position) {
		_isPerformingAction = true;
		_player.stateMachine.GetState<StateMove>("Move").MoveTo(position, () => _isPerformingAction = false);
	}

	public bool HasValidActor(ActionSetup actionSetup, Actor actor) {
		var requiresActor = actionSetup.targetType == ActionSetup.TargetTypes.Actor;
		if (!requiresActor) {
			return true; // No need to check anything else.
		}

		if (actor == null) {
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
}