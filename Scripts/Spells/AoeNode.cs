using Godot;
using Starbattle.Controllers;

namespace Starbattle.Spells;

[GlobalClass]
public partial class AoeNode : Node3D {
	public enum FilterTypes { Opponents, Friends, Any }

	public Actor _actor;

	public ActionSetup _actionSetup;

	[Export]
	public Area3D _area;

	[Export]
	public FilterTypes _filterType = FilterTypes.Opponents;

	public void Initialize(ActionSetup actionSetup, Actor actor) {
		_actor = actor;
		_actionSetup = actionSetup;

		_area.CollisionLayer = TargetingController.instance.GetOpposingMask(actor);
		_area.CollisionMask = _area.CollisionLayer;
	}

	public void Attack(ActionSetup actionSetup) {
		if (!Multiplayer.IsServer()) {
			return;
		}

		var bodies = _area.GetOverlappingBodies();
		var hits = 0;

		foreach (var body in bodies) {
			var target = body.GetParent<Actor>();
			if (target == null) {
				continue;
			}

			var canTarget = IsTarget(_actor, target);
			if (!canTarget) {
				continue;
			}

			var damage = GetDamage(actionSetup, target);
			target.Damage(_actor, damage, false, hits);

			hits += 1;
		}
	}

	public bool IsTarget(Actor actor, Actor target) {
		if (target == null) {
			return false;
		}

		switch (_filterType) {
			case FilterTypes.Opponents when actor.IsPlayerGroup == target.IsPlayerGroup:
			case FilterTypes.Friends when actor.IsPlayerGroup != target.IsPlayerGroup:
				return false;

			case FilterTypes.Any:
			default:
				return true;
		}
	}

	public float GetDamage(ActionSetup actionSetup, Actor target) {
		return actionSetup.damageType switch {
			ActionSetup.DamageTypes.Physical => _actor.stats.GetPhysicalDamage(actionSetup.power, target),
			ActionSetup.DamageTypes.Magical => _actor.stats.GetMagicalDamage(actionSetup.power, target),
			_ => 0f
		};
	}
}