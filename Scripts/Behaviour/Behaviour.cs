using Godot;

namespace Starbattle;

[GlobalClass]
public partial class Behaviour : Resource {
	[Export]
	public ActionCheck[] actionChecks;

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

	public bool TryNextAction(Actor actor) {
		var success = TryGetClosestOpponent(actor, out var closest);
		if (!success) {
			return false;
		}

		var isInRange = actor.action.IsInRange(closest);
		if (isInRange) {
			return actor.action.TryRequestAction("Attack", closest, closest.GlobalPosition);
		}

		return actor.action.TryRequestAction("Move", closest, closest.GlobalPosition);
	}
}