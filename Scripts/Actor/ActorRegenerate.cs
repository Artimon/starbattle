using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorRegenerate : Timer {
	[Export]
	public Actor _actor;

	public void OnTick() {
		if (!_actor.IsHurt || _actor.IsDead) {
			return;
		}

		var heal = Mathf.Max(1f, _actor.MaxHp * 0.02f); // @TODO Insert regen status.

		_actor.Heal(heal, false); // Show full healing potential, not actual heal.
	}
}