using Godot;

namespace Starbattle;

[GlobalClass]
public partial class EffectContainer : Node3D {
	public static EffectContainer instance;

	public override void _EnterTree() {
		instance = this;
	}

	public override void _ExitTree() {
		instance = null;
	}

	public T Instantiate<T>(PackedScene prefab, Vector3 spellPosition) where T : Node3D {
		return prefab.Instantiate<T>(this, spellPosition);
	}
}