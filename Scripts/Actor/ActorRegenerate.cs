using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorRegenerate : Timer {
	[Export]
	public Actor _actor;

	public void OnTick() {
		if (!_actor.IsHpMissing || _actor.IsDead) {
			return;
		}

		var heal = Mathf.Max(1f, _actor.MaxHp * 0.02f); // @TODO Insert regen status.
		var refresh = Mathf.Max(1f, _actor.MaxSp * 0.03f);

		_actor.Heal(heal, false); // Show full healing potential, not actual heal.
		_actor.Refresh(refresh, false);
	}
}