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

	public void MagicAttack(float power) {
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

			var damage = _actor.stats.GetMagicalDamage(power, target);
			target.Damage(damage, false);
		}
	}
}