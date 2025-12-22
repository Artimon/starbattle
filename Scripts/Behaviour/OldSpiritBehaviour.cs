using Godot;

namespace Starbattle;

[GlobalClass]
public partial class OldSpiritBehaviour : DefaultBehaviour {
	[Export]
	public ActionSetup _regenerateSp;

	[Export]
	public ActionSetup _holyLight;

	public override bool TryCustomAction(Actor actor, Actor target) {
		if (IsSpBelow(actor, 0.25f) && ProbeChance(0.1f)) {
			actor.action.TryRequestAction(_regenerateSp, actor, actor.GlobalPosition);

			return true;
		}

		if (IsHpBelow(actor, 0.5f) && ProbeChance(0.4f)) {
			actor.action.TryRequestAction("RegenerateHp", actor, actor.GlobalPosition);

			return true;
		}

		if (_holyLight.HasSp(actor) && ProbeChance(0.6f)) {
			actor.action.TryRequestAction(_holyLight, target, target.GlobalPosition);

			return true;
		}

		return false;
	}
}