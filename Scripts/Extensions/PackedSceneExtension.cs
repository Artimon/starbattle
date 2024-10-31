using System;
using Godot;

namespace Artimus.Extensions;

public static class PackedSceneExtension {
	public static T Instantiate<T>(this PackedScene packedScene, Node3D parent) where T : Node3D {
		var thing = packedScene.Instantiate<T>();

		parent.AddChild(thing);
		thing.GlobalPosition = parent.GlobalPosition;

		return thing;
	}

	public static T InstantiateNetworked<T>(
		this PackedScene packedScene,
		Node3D parent,
		long uniqueId,
		Action<T> preAdd = null
	) where T : Node3D {
		var thing = packedScene.Instantiate<T>();

		preAdd?.Invoke(thing);
		parent.AddChild(thing);

		thing.GlobalPosition = parent.GlobalPosition;
		thing.Name = $"{thing.Name} {uniqueId}"; // For network identification.

		return thing;
	}
}