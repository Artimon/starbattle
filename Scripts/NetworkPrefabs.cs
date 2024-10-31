using System;
using System.Collections.Generic;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class NetworkPrefabs : Node {
	[Export]
	public PackedScene[] _prefabs;

	[Export]
	public Node3D _container;

	public List<NetworkNode3D> _things = new ();

	public Action<NetworkNode3D> onInstantiated;

	public override void _EnterTree() {
		Multiplayer.PeerConnected += (clientId) => {
			if (!Multiplayer.IsServer()) {
				return;
			}

			foreach (var thing in _things.ToArray()) {
				Instantiate(thing, clientId);
			}
		};
	}

	public int GetPrefabIndex(PackedScene prefab) {
		var prefabIndex = Array.IndexOf(_prefabs, prefab);
		if (prefabIndex == -1) {
			throw new Exception("Prefab not found in NetworkPrefabs.");
		}

		return prefabIndex;
	}

	[Rpc(CallLocal = true)]
	public void _RpcInstantiate(int prefabIndex, Vector3 position, long ownerId) {
		var prefab = _prefabs[prefabIndex];
		var thing = prefab.Instantiate<NetworkNode3D>();

		thing.Name = $"{thing.Name} {ownerId}"; // For network identification.
		thing.ownerId = ownerId;
		thing.prefabIndex = prefabIndex;

		_container.AddChild(thing); // Now "_EnterTree" is called.
		_things.Add(thing);

		thing.GlobalPosition = position;
		thing.OnExitTree += OnNodeExitingTree;

		onInstantiated?.Invoke(thing);

		// var node = prefab.InstantiateNetworked<NetworkNode3D>(_container, ownerId, (actor) => {
		// 	actor.ownerId = ownerId;
		// });
		//
		// node.GlobalPosition = position;
		//
		// onInstantiated?.Invoke(node);
	}

	public void Instantiate(NetworkNode3D thing, long recipientId) {
		RpcId(recipientId, nameof(_RpcInstantiate), thing.prefabIndex, thing.GlobalPosition, thing.ownerId);
	}

	public void Instantiate(PackedScene prefab, Vector3 position) {
		var prefabIndex = GetPrefabIndex(prefab);
		var ownerId = Multiplayer.GetUniqueId();

		Rpc(nameof(_RpcInstantiate), prefabIndex, position, ownerId);
	}

	public void OnNodeExitingTree(NetworkNode3D thing) {
		_things.Remove(thing);
	}
}