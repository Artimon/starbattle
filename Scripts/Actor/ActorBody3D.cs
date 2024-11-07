﻿using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorBody3D : CharacterBody3D {
	[Export]
	public ActorBase _actor;

	public ActorBase Actor => _actor;

	// public override void _Input(InputEvent @event) {
	// 	if (@event is InputEventMouseButton { Pressed: true } mouseEvent) {
	// 		GD.Print($"Mouse pressed on {_actor.Name}");
	// 	}
	// }
}