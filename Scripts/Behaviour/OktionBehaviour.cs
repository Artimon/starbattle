using Godot;

namespace Starbattle;

[GlobalClass]
public partial class OktionBehaviour : DefaultBehaviour {
	[Export]
	public ActionSetup _holyLight;

	public override bool TryCustomAction(Actor actor, Actor target) {
		if (_holyLight.HasSp(actor) && ProbeChance(0.45f)) {
			return actor.action.TryRequestAction(_holyLight, target, target.GlobalPosition);
		}

		return false;
	}
}