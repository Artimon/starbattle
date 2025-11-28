using System;
using Godot;

namespace Artimus.Extensions;

public static class PackedSceneExtensions {
	public static T Instantiate<T>(this PackedScene packedScene, Node3D parent) where T : Node3D {
		var thing = packedScene.Instantiate<T>();

		parent.AddChild(thing);
		thing.GlobalPosition = parent.GlobalPosition;

		return thing;
	}

	/**
	 * With AddChild() the objects _EnterTree() and _Ready() methods are called, before the method returns.
	 */
	public static T Instantiate<T>(
		this PackedScene packedScene,
		Node3D parent,
		Action<T> onBeforeAdd
	) where T : Node3D {
		var thing = packedScene.Instantiate<T>();

		onBeforeAdd?.Invoke(thing);
		parent.AddChild(thing);

		// Disabled as it overwrites positions set in onBeforeAdd;
		// thing.GlobalPosition = parent.GlobalPosition;

		return thing;
	}
}