using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActionSetup : Resource {
	public enum ActionTypes { Move, Attack, Regenerate, Special }

	public enum DamageTypes { Physical, Magical, True }

	public enum TargetTypes { Position, Opponent, Friend, None }

	public enum Conditions { None, IsHpMissing, IsSpMissing }

	[Export]
	public string name;

	public uint ActionId => name.Hash();

	[Export]
	public int actionCost;

	[Export]
	public float spCost;

	[Export]
	public float power;

	[Export]
	public ActionTypes actionType;

	[Export]
	public DamageTypes damageType;

	[Export]
	public TargetTypes targetType;

	public bool TargetsActor => targetType is TargetTypes.Opponent or TargetTypes.Friend;

	[Export]
	public Conditions condition;

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

	public bool MeetsCondition(Actor actor) {
		switch (condition) {
			case Conditions.IsHpMissing:
				return actor.IsHpMissing;

			case Conditions.IsSpMissing:
				return actor.IsSpMissing;

			case Conditions.None:
			default:
				return true;
		}
	}
}