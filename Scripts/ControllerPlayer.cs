﻿using System.Collections.Generic;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ControllerPlayer : Node {
	[Export]
	public Node3D _actorContainer;

	[Export]
	public PackedScene[] _playerPrefabs;

	public readonly List<Actor> _players = new();

	[Rpc(CallLocal = true)]
	public void _SpawnPlayer(int actorPrefabIndex, Vector3 position, long uniqueId) {
		var prefab = _playerPrefabs[actorPrefabIndex];

		var actor = prefab.InstantiateNetworked<Actor>(_actorContainer, uniqueId, (actor) => {
			actor.ownerId = uniqueId;
			actor.prefabIndex = actorPrefabIndex;
		});

		actor.GlobalPosition = position;

		_players.Add(actor);
	}

	public void SendAllPlayersToNewPlayer(long recipientId) {
		foreach (var playerActor in _players.ToArray()) {
			RpcId(recipientId, nameof(_SpawnPlayer), playerActor.prefabIndex, playerActor.GlobalPosition, playerActor.ownerId);
		}
	}

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

		// @TODO Check if the player is already spawned.
		var ownerId = Multiplayer.GetRemoteSenderId();
		var position = new Vector3(
			-2f + 2f * _players.Count,
			0f,
			0f
		);

		Rpc(nameof(_SpawnPlayer), actorPrefabIndex, position, ownerId);
	}
}