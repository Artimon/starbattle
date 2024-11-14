using System.Collections.Generic;
using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorContainer : Node3D {
	public static ActorContainer instance;

	public readonly Dictionary<long, ActorBase> _actors = new();
	public readonly Dictionary<long, ActorPlayer> _players = new();
	public readonly Dictionary<long, ActorMob> _mobs = new();

	public ActorBase[] Actors => _actors.Values.ToArray();
	public ActorPlayer[] Players => _players.Values.ToArray();
	public ActorMob[] Mobs => _mobs.Values.ToArray();

	public override void _EnterTree() {
		instance = this;
	}

	public void Add(ActorBase actor) {
		var handle = actor.serverSynchronizer.networkHandle;

		_actors.Add(handle, actor);

		switch (actor) {
			case ActorPlayer actorPlayer:
				_players.Add(handle, actorPlayer);
				break;

			case ActorMob actorMob:
				_mobs.Add(handle, actorMob);
				break;
		}
	}

	public void Remove(ActorBase actor) {
		var handle = actor.serverSynchronizer.networkHandle;

		_actors.Remove(handle);

		switch (actor) {
			case ActorPlayer actorPlayer:
				_players.Remove(handle);
				break;

			case ActorMob actorMob:
				_mobs.Remove(handle);
				break;
		}
	}

	public bool TryGetActor(long networkHandle, out ActorBase actor) {
		return _actors.TryGetValue(networkHandle, out actor);
	}

	public bool TryGetPlayer(long networkHandle, out ActorPlayer player) {
		return _players.TryGetValue(networkHandle, out player);
	}

	public bool TryGetMob(long networkHandle, out ActorMob mob) {
		return _mobs.TryGetValue(networkHandle, out mob);
	}
}