using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActionSetup : Resource {
	public enum ActionTypes { Move, Attack }

	public enum TargetTypes { Position, Opponent, Friend, None }

	[Export]
	public string name;

	public uint ActionId => name.Hash();

	[Export]
	public int actionCost;

	[Export]
	public ActionTypes actionType;

	[Export]
	public TargetTypes targetType;

	public bool TargetsActor => targetType is TargetTypes.Opponent or TargetTypes.Friend;
}