using System.Collections.Generic;
using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorContainer : Node3D {
	public static ActorContainer instance;

	public readonly Dictionary<long, Actor> _actors = new();

	public Actor[] Actors => _actors.Values.ToArray();

	public override void _EnterTree() {
		instance = this;
	}

	public void Add(Actor actor) {
		var handle = actor.synchronizer.handle;

		_actors.Add(handle, actor);
	}

	public void Remove(Actor actor) {
		var handle = actor.synchronizer.handle;

		_actors.Remove(handle);
	}
}