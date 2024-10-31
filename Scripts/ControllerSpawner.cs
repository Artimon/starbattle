using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ControllerSpawner : Node {
	[Export]
	public MultiplayerContainer _multiplayerContainer;

	[Export]
	public NetworkPrefabs _networkPrefabs;

	[Export]
	public Node3D _spawnPoint;

	[Export]
	public PackedScene _mobPrefab;

	public override void _EnterTree() {
		SetProcess(false);

		_networkPrefabs.onInstantiated += (thing) => {
			var actor = (Actor)thing;

			actor.isMob = true;

			// GD.Print($"Mob spawned: {actor.Name} at peer {Multiplayer.GetUniqueId()} for {actor.ownerId}");
		};

		_multiplayerContainer.OnConnectionReady += () => {
			if (Multiplayer.IsServer()) {
				_Begin();
			}
		};
	}

	public void _Begin() {
		_networkPrefabs.Instantiate(_mobPrefab, _spawnPoint.GlobalPosition);
	}
}