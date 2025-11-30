using System;
using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class MultiplayerContainer : Node {
	[Export]
	public ActorSpawner _actorSpawner;

	public event Action OnConnectionReady;

	public override void _Ready() {
		Multiplayer.PeerConnected += (id) => {
			// Print("Peer connected: " + id);
			// _controllerPlayer.SpawnPlayer(id);
			// _controllerPlayer.RequestPlayerSpawn(0, _controllerPlayer._player1Prefab);
		};

		Multiplayer.PeerDisconnected += (id) => {
			// Print("Peer disconnected: " + id);
		};

		var args = OS.GetCmdlineArgs(); // OS.GetCmdlineUserArgs() for overwrites.

		if (args.Contains("--server")) {
			CreateServer();
		}
		else {
			ConnectToServer();
		}
	}

	public void Print(string message) {
		var peer = Multiplayer.IsServer() ? "Server" : "Client";
		var uniqueId = Multiplayer.GetUniqueId();

		GD.Print($"{peer} ({uniqueId}): {message}");
	}

	public void CreateServer() {
		var peer = new ENetMultiplayerPeer();
		var status = peer.CreateServer(8910, 4);
		if (status != Error.Ok) {
			GD.Print("Failed to create server.");
			return;
		}

		OnConnectionReady?.Invoke();

		// peer.Host.Compress(ENetConnection.CompressionMode.RangeCoder);
		Multiplayer.MultiplayerPeer = peer; // Assigning the peer triggers the connection.

		var uniqueId = Multiplayer.GetUniqueId();
		// var isServer = Multiplayer.IsServer();

		// Print($"ID {uniqueId}, {peer.GetConnectionStatus()}");

		_actorSpawner.RequestPlayerSpawnViaRpcId("Wizard");

		DisplayServer.WindowSetTitle($"Starbattle Server: {uniqueId}");
		DisplayServer.WindowSetPosition(new Vector2I(768, 382));
	}

	public void ConnectToServer() {
		Multiplayer.ConnectedToServer += () => {
			// Print("Connected to server.");
			OnConnectionReady?.Invoke();

			var uniqueId = Multiplayer.GetUniqueId();

			DisplayServer.WindowSetTitle($"Starbattle Client: {uniqueId}");
			DisplayServer.WindowSetPosition(new Vector2I(0, 30));

			_actorSpawner.RequestPlayerSpawnViaRpcId("Valkyrie");
		};

		Multiplayer.ConnectionFailed += () => {
			GD.Print("Connection to server failed.");
		};

		Multiplayer.ServerDisconnected += () => {
			GD.Print("Disconnected from server.");
		};

		var peer = new ENetMultiplayerPeer();
		var status = peer.CreateClient("127.0.0.1", 8910);
		if (status != Error.Ok) {
			GD.Print("Failed to connect to server.");
			return;
		}

		// peer.Host.Compress(ENetConnection.CompressionMode.RangeCoder);
		Multiplayer.MultiplayerPeer = peer; // Assigning the peer triggers the connection.

		// Print($"Now connecting to server... {peer.GetConnectionStatus()}");
	}
}