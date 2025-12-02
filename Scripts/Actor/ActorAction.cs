using Godot;
using TargetTypes = Starbattle.ActionSetup.TargetTypes;

namespace Starbattle;

[GlobalClass]
public partial class ActorAction : Node {
	[Export]
	public Actor _player;

	[Export]
	public ActionSetups _actionSetups;

	public bool IsIdle => _player.stateMachine.IsInState("Idle");

	/**
	 * This time we sanitize on client, cuz who's gonna manipulate this anyway, riiight?
	 */
	public bool TryRequestAction(ActionSetup actionSetup, Actor actor, Vector3 position) {
		if (
			actionSetup.TargetsActor &&
			!HasValidActor(actionSetup, actor)
		) {
			GD.Print("False");
			return false;
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

		switch (action.actionType) {
			case ActionSetup.ActionTypes.Move:
				targetPosition = GetLimitedPosition(position);

				break;

			case ActionSetup.ActionTypes.Attack:
				var actor = Actor.Resolve(actorHandle);
				if (actor == null) {
					return;
				}

				targetPosition = GetAttackPosition(actor);

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
				PerformAttack(actorHandle, position);

				break;
		}
	}

	public void PerformMove(Vector3 position) {
		_player.stateMachine.Get<StateMove>().MoveTo(position);
	}

	/**
	 * Clients are allowed to decide if they need to move or not, just like in the original game.
	 */
	public void PerformAttack(uint actorHandle, Vector3 position) {
		var actor = Actor.Resolve(actorHandle);
		if (actor == null) {
			return; // Not synchronized or already removed.
		}

		var playerPosition = _player.GlobalPosition;
		var distance = playerPosition.DistanceTo(position);

		if (distance <= 0.35f) {
			_player.stateMachine
				.Get<StateAttack>()
				.Attack(actor);

			return;
		}

		_player.stateMachine
			.Get<StateMove>()
			.MoveTo(position, () => {
				_player.stateMachine
					.Get<StateAttack>()
					.Attack(actor);
			});
	}

	public bool HasValidActor(ActionSetup actionSetup, Actor actor) {
		if (actor == null) {
			return false;
		}

		switch (actionSetup.targetType) {
			case TargetTypes.Opponent when actor.IsPlayerGroup == _player.IsPlayerGroup:
			case TargetTypes.Friend when actor.IsPlayerGroup != _player.IsPlayerGroup:
				return false;

			default:
				return IsInRange(actor);
		}
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