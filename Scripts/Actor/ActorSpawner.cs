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
	).Normalized() * 8f;

	public override void _Ready() {
		// All start as "server" (id 1) only when the connection is established, the client will be marked as "client".
		instance = this;

		_multiplayerContainer.OnConnectionReady += () => {
			if (!Multiplayer.IsServer()) {
				return;
			}

			CreateMob(RandomSpawnPosition, _setups.GetSetup("ElderGhost"));
		};

	}

	public void CreateMob(Vector3 position, ActorSetup setup) {
		var actor = _actorPrefab.Instantiate<Actor>(_actorContainer, actor => {
			actor.synchronizer.handle = GD.Randi();
			actor.synchronizer.actorId = setup.ActorId;
			actor.synchronizer.spawnPosition = position;
			actor.Name = $"{setup.name} {actor.synchronizer.handle}";
		});
	}

	public void CreatePlayer(Vector3 position, string actorName, int playerId) {
		var setup = _setups.GetSetup(actorName);
		var actor = _actorPrefab.Instantiate<Actor>(_actorContainer, actor => {
			actor.synchronizer.handle = GD.Randi();
			actor.synchronizer.playerId = playerId;
			actor.synchronizer.actorId = setup.ActorId;
			actor.synchronizer.spawnPosition = position;
			actor.Name = $"{setup.name} {actor.synchronizer.handle}";
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
			actorName,
			Multiplayer.GetRemoteSenderId()
		);
	}

	public override void _ExitTree() {
		instance = null;
	}
}