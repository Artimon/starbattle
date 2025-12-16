using Godot;

namespace Starbattle;

[GlobalClass]
public partial class DragonBehaviour : DefaultBehaviour {
	[Export]
	public ActionSetup _regenerateHp;

	public override bool TryCustomAction(Actor actor, Actor target) {
		if (IsHpBelow(actor, 0.5f) && ProbeChance(0.8f)) {
			actor.action.TryRequestAction(_regenerateHp, actor, actor.GlobalPosition);
		}

		return true;
	}
}