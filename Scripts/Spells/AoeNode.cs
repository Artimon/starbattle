using Godot;

namespace Starbattle.Spells;

[GlobalClass]
public partial class AoeNode : Node3D {
	public Actor _actor;

	public ActionSetup _actionSetup;

	[Export]
	public Area3D _area;

	public void Initialize(ActionSetup actionSetup, Actor actor) {
		_actor = actor;
		_actionSetup = actionSetup;
	}

	public void Attack(ActionSetup actionSetup) {
		if (!Multiplayer.IsServer()) {
			return;
		}

		var bodies = _area.GetOverlappingBodies();
		foreach (var body in bodies) {
			var target = body.GetParent<Actor>();
			if (target == null) {
				continue;
			}

			var canTarget = _actionSetup.CanTarget(_actor, target);
			if (!canTarget) {
				continue;
			}

			var damage = GetDamage(actionSetup, target);
			target.Damage(damage, false);
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