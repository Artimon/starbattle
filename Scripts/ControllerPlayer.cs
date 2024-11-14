using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ControllerPlayer : Node {
	[Export]
	public Node3D _actorContainer;

	[Export]
	public PackedScene[] _playerPrefabs;

	public void RpcIdRequestPlayerSpawn(int actorPrefabIndex) {
		RpcId(1, nameof(_RequestPlayerSpawn), actorPrefabIndex);
	}

	/**
	 * Important:
	 * During initialization of the network, not all clients may know the other peers, yet.
	 * Hence, only requesting the server is reliable, since the server MUST know all peers.
	 */
	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
	public void _RequestPlayerSpawn(int actorPrefabIndex) {
		if (!Multiplayer.IsServer()) {
			return;
		}

		var prefab = _playerPrefabs[actorPrefabIndex];
		var actor = prefab.Instantiate<ActorPlayer>(_actorContainer, (actor) => {
			actor.serverSynchronizer.networkHandle = GD.Randi(); // @TODO Get from a global system that ensure 100% unique identifiers.
			actor.serverSynchronizer.ownerId = Multiplayer.GetRemoteSenderId();
			actor.Name = $"{actor.Name} {actor.serverSynchronizer.networkHandle}";
		});
	}
}