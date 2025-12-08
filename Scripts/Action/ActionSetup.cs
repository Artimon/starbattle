using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActionSetup : Resource {
	public enum ActionTypes { Move, Attack, Skill, Magic }

	public enum TargetTypes { Position, Opponent, Friend, None }

	[Export]
	public string name;

	public uint ActionId => name.Hash();

	[Export]
	public int actionCost;

	[Export]
	public float power;

	[Export]
	public ActionTypes actionType;

	[Export]
	public TargetTypes targetType;

	public bool TargetsActor => targetType is TargetTypes.Opponent or TargetTypes.Friend;

	[Export]
	public PackedScene aoePrefab;

	[Export]
	public PackedScene pointPrefab;

	public bool CanTarget(Actor actor, Actor target) {
		if (target == null) {
			return false;
		}

		switch (targetType) {
			case TargetTypes.Opponent when actor.IsPlayerGroup == target.IsPlayerGroup:
			case TargetTypes.Friend when actor.IsPlayerGroup != target.IsPlayerGroup:
				return false;

			case TargetTypes.Position:
			case TargetTypes.None:
			default:
				return true;
		}
	}
}