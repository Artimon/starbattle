using System.Collections.Generic;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ControllerSpawner : Node {
	public static ControllerSpawner instance;

	[Export]
	public MultiplayerContainer _multiplayerContainer;

	[Export]
	public NetworkPrefabs _networkPrefabs;

	[Export]
	public Node3D _spawnPoint;

	[Export]
	public PackedScene _mobPrefab;

	public List<ActorMob> _mobs = new ();

	public ActorMob[] Mobs => _mobs.ToArray();

	public Vector3 RandomSpawnPosition => _spawnPoint.GlobalPosition + new Vector3(
		GD.Randf(),
		0f,
		GD.Randf()
	).Normalized() * 5f;

	public override void _EnterTree() {
		instance = this;

		SetProcess(false);

		_networkPrefabs.onInstantiated += (thing) => {
			var actor = (ActorMob)thing;

			actor.OnDeath += (actor) => {
				_mobs.Remove((ActorMob)actor);
			};

			_mobs.Add(actor);

			// GD.Print($"Mob spawned: {actor.Name} at peer {Multiplayer.GetUniqueId()} for {actor.ownerId}");
		};

		_multiplayerContainer.OnConnectionReady += () => {
			if (Multiplayer.IsServer()) {
				_Begin();
			}
		};
	}

	public void _Begin() {
		_networkPrefabs.Instantiate(_mobPrefab, RandomSpawnPosition);
		_networkPrefabs.Instantiate(_mobPrefab, RandomSpawnPosition);
		_networkPrefabs.Instantiate(_mobPrefab, RandomSpawnPosition);
	}
}