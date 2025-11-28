using System.Collections.Generic;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ControllerSpawner : Node {
	public static ControllerSpawner instance;

	[Export]
	public MultiplayerContainer _multiplayerContainer;

	[Export]
	public ActorContainer _actorContainer;

	[Export]
	public Node3D _spawnPoint;

	[Export]
	public PackedScene _mobPrefab;

	[Export]
	public PackedScene _actorPrefab;

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

		_multiplayerContainer.OnConnectionReady += () => {
			if (Multiplayer.IsServer()) {
				_Begin();
			}
		};
	}

	public void _Begin() {
		// _mobPrefab.Instantiate<ActorMob>(_actorContainer, (actor) => {
		// 	actor.serverSynchronizer.networkHandle = GD.Randi(); // @TODO Get from a global system that ensure 100% unique identifiers.
		// 	actor.Name = $"{actor.Name} {actor.serverSynchronizer.networkHandle}";
		// });

		_actorPrefab.Instantiate<Actor>(_actorContainer, actor => {
			actor.synchronizer.handle = GD.Randi();
			actor.synchronizer.ownerId = actor._setups.setups[1].ActorId;
			actor.Name = $"{actor.Name} {actor.synchronizer.handle}";
		});
	}
}