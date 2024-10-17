using Godot;
using System;

namespace Starbattle;

[GlobalClass]
public partial class Client : Node {
	public bool _connected;

	public override void _Ready() {
		Multiplayer.ConnectedToServer += () => {
			GD.Print("Connected to server as client.");
		};

		Multiplayer.ConnectionFailed += () => {
			GD.Print("Connection failed.");
		};

		Multiplayer.ServerDisconnected += () => {
			GD.Print("Disconnected from server as client.");
		};
	}

	public override void _Process(double delta) {
		var isPressed = Input.IsKeyPressed(Key.P);
		if (!isPressed) {
			return;
		}

		ConnectToServer();
	}

	public void ConnectToServer() {
		if (_connected) {
			return;
		}

		// Create Client.
		var peer = new ENetMultiplayerPeer();
		var status = peer.CreateClient("127.0.0.1", 8910);
		if (status != Error.Ok) {
			GD.Print("Failed to connect to server.");
			return;
		}

		// peer.Host.Compress(ENetConnection.CompressionMode.RangeCoder);
		// Assigning the peer triggers the connection.
		Multiplayer.MultiplayerPeer = peer;

		GD.Print($"Now connecting to server as client... {peer.GetConnectionStatus()}");

		_connected = true;
	}

	[Rpc]
	public void IdentifySelf(string message) {
		var uniqueId = Multiplayer.GetUniqueId();
		var isServer = Multiplayer.IsServer();

		GD.Print($"Client setup: {uniqueId} {isServer} with message: {message}");
	}

	public void Terminate() {
		Multiplayer.MultiplayerPeer = null;
	}
}