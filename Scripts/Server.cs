using Godot;
using System;

namespace Starbattle;

public partial class Server : Node {
	[Export]
	public Client _client;

	public bool _connected;

	public override void _Ready() {
		var multiplayer = MultiplayerApi.CreateDefaultInterface();
		GetTree().SetMultiplayer(multiplayer, GetPath());

		Multiplayer.PeerConnected += (id) => {
			GD.Print("Client connected: " + id);

			Multiplayer.Rpc(
				(int)id,
				_client,
				nameof(Client.IdentifySelf),
				new (){ "Cool message!" }
			);
		};

		Multiplayer.PeerDisconnected += (id) => {
			GD.Print("Client disconnected: " + id);
		};
	}

	public override void _Process(double delta) {
		var isPressed = Input.IsKeyPressed(Key.O);
		if (!isPressed) {
			return;
		}

		CreateServer();
	}

	public void CreateServer() {
		if (_connected) {
			return;
		}

		var peer = new ENetMultiplayerPeer();
		var status = peer.CreateServer(8910, 4);
		if (status != Error.Ok) {
			GD.Print("Failed to create server.");
			return;
		}

		// peer.Host.Compress(ENetConnection.CompressionMode.RangeCoder);
		Multiplayer.MultiplayerPeer = peer;

		var uniqueId = Multiplayer.GetUniqueId();
		var isServer = Multiplayer.IsServer();

		GD.Print($"Server setup: {uniqueId} {isServer} {peer.GetConnectionStatus()}");

		_connected = true;
	}

	public void Terminate() {
		Multiplayer.MultiplayerPeer = null;
	}
}