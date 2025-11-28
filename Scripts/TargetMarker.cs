using System;
using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class TargetMarker : Node3D {
	public static TargetMarker instance;

	public Actor _target;

	public Actor Target {
		get => _target;
		set => _target = value;
	}

	public override void _EnterTree() {
		instance = this;
	}

	/**
	 * Is called after all actor updates, since it is placed further down in the scene tree.
	 */
	public override void _Process(double delta) {
		if (_target != null) {
			GlobalPosition = _target.GlobalPosition;
		}
	}

	public void TargetCloser() {
		// var mobs = ControllerSpawner.instance.Mobs;
		// if (mobs.Length == 0) {
		// 	return;
		// }
		//
		// var position = ActorPlayer.player.GlobalPosition;
		// var sortedMobs = mobs
		// 	.OrderByDescending(mob => mob.GlobalPosition.DistanceTo(position))
		// 	.ToArray();
		//
		// var index = Array.IndexOf(sortedMobs, _target);
		// index = (index + 1) % sortedMobs.Length;
		//
		// _target = sortedMobs[index];
		//
		// if (_target != null) {
		// 	GD.Print($"Targeted closer: {_target.Name}");
		// }
	}

	public void TargetFurther() {
		// var mobs = ControllerSpawner.instance.Mobs;
		// if (mobs.Length == 0) {
		// 	return;
		// }
		//
		// var position = ActorPlayer.player.GlobalPosition;
		// var sortedMobs = mobs
		// 	.OrderBy(mob => mob.GlobalPosition.DistanceTo(position))
		// 	.ToArray();
		//
		// var index = Array.IndexOf(sortedMobs, _target);
		// index = (index + 1) % sortedMobs.Length;
		//
		// _target = sortedMobs[index];
		//
		// if (_target != null) {
		// 	GD.Print($"Targeted closer: {_target.Name}");
		// }
	}
}