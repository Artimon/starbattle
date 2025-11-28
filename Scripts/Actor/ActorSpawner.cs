using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorSpawner : Node {
	public static ActorSpawner instance;

	[Export]
	public MultiplayerContainer _multiplayerContainer;

	[Export]
	public ActorContainer _actorContainer;

	[Export]
	public PackedScene _actorPrefab;

	[Export]
	public ActorSetups _setups;

	public static Vector3 RandomSpawnPosition => new Vector3(
		GD.Randf(),
		0f,
		GD.Randf()
	).Normalized() * 5f;

	public override void _EnterTree() {
		if (!Multiplayer.IsServer()) {
			return;
		}

		instance = this;

		// _multiplayerContainer.OnConnectionReady += _Begin;
	}

	public void CreatePlayer(Vector3 position, uint actorId, int playerId) {
		var actor = _actorPrefab.Instantiate<Actor>(_actorContainer, actor => {
			actor.synchronizer.handle = GD.Randi();
			actor.synchronizer.playerId = playerId;
			actor.synchronizer.actorId = actorId;
			actor.synchronizer.spawnPosition = position;
			actor.Name = $"{actor.Name} {actor.synchronizer.handle}";
		});
	}

	public void RequestPlayerSpawnViaRpcId(string actorName) {
		RpcId(1, nameof(_RequestPlayerSpawn), actorName);
	}

	/**
	 * Important:
	 * During initialization of the network, not all clients may know the other peers, yet.
	 * Hence, only requesting the server is reliable, since the server MUST know all peers.
	 */
	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
	public void _RequestPlayerSpawn(string actorName) {
		if (!Multiplayer.IsServer()) {
			return;
		}

		CreatePlayer(
			RandomSpawnPosition,
			_setups.GetSetup(actorName).ActorId,
			Multiplayer.GetRemoteSenderId()
		);
	}

	public override void _ExitTree() {
		instance = null;
	}
}