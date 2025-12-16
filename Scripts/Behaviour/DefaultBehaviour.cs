using Godot;

namespace Starbattle;

[GlobalClass]
public partial class DefaultBehaviour : Resource {
	public bool TryGetClosestOpponent(Actor actor, out Actor closest) {
		var isPlayerGroup = actor.IsPlayerGroup;
		var closestDist = float.MaxValue;

		closest = null;

		foreach (var otherActor in Actor.actors) {
			if (otherActor == actor) {
				continue;
			}

			if (otherActor.IsPlayerGroup == isPlayerGroup) {
				continue;
			}

			if (otherActor.IsDead) {
				continue;
			}

			var distance = actor.GlobalPosition.DistanceSquaredTo(otherActor.GlobalPosition);
			if (distance < closestDist) {
				closestDist = distance;
				closest = otherActor;
			}
		}

		return closest != null;
	}

	public bool IsHpBelow(Actor actor, float threshold) {
		return actor.hp < actor.MaxHp * threshold;
	}

	public bool ProbeChance(float chance) {
		return GD.Randf() < chance;
	}

	public virtual bool TryCustomAction(Actor actor, Actor target) {
		return false;
	}

	public bool TryNextAction(Actor actor) {
		var success = TryGetClosestOpponent(actor, out var closest);
		if (!success) {
			return false;
		}

		var isInRange = actor.action.IsInRange(closest);
		if (!isInRange) {
			return actor.action.TryRequestAction("Move", closest, closest.GlobalPosition);
		}

		var startsAction = TryCustomAction(actor, closest);
		if (startsAction) {
			return true;
		}

		return actor.action.TryRequestAction("Attack", closest, closest.GlobalPosition);
	}
}