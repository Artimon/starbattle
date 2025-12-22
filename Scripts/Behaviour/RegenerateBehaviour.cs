using Godot;

namespace Starbattle;

[GlobalClass]
public partial class RegenerateBehaviour : DefaultBehaviour {
	[Export]
	public ActionSetup _regenerateHp;

	[Export]
	public float _hpThreshold = 0.5f;

	[Export]
	public float _probability = 0.8f;

	public override bool TryCustomAction(Actor actor, Actor target) {
		if (IsHpBelow(actor, _hpThreshold) && ProbeChance(_probability)) {
			actor.action.TryRequestAction(_regenerateHp, actor, actor.GlobalPosition);
		}

		return true;
	}
}