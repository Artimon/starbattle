using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorAction : Node {
	[Export]
	public Actor _player;
	public bool _isPerformingAction;

	public void RequestAction(int actionId, Vector3 position) {
		RpcId(1, nameof(_RpcRequestAction), actionId, position);
	}

	/**
	 * Important:
	 * During initialization of the network, not all clients may know the other peers, yet.
	 * Hence, only requesting the server is reliable, since the server MUST know all peers.
	 */
	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
	public void _RpcRequestAction(int actionId, Vector3 position) {
		if (!Multiplayer.IsServer()) {
			return;
		}

		if (_isPerformingAction) {
			// Maybe communicate back to re-open the action menu?
			return;
		}

		var playerPosition = _player.GlobalPosition;
		var distance = position - playerPosition;
		if (distance.Length() > _player.actionRange) {
			position = playerPosition + distance.Normalized() * _player.actionRange;
		}

		Rpc(nameof(RpcBeginAction), actionId, position);
	}

	[Rpc(CallLocal = true)]
	public void RpcBeginAction(int actionId, Vector3 position) {
		_isPerformingAction = true;
		_player.stateMachine.GetState<StateMove>("Move").MoveTo(position, () => _isPerformingAction = false);
	}
}