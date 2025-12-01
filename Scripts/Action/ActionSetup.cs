using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActionSetup : Resource {
	public enum ActionTypes { Move, Attack }

	public enum TargetTypes { Ground, Actor, Self }

	[Export]
	public string name;

	public uint ActionId => name.Hash();

	[Export]
	public ActionTypes actionType;

	[Export]
	public TargetTypes targetType;
}