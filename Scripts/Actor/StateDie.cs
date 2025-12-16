using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class StateDie : StateBase {
	[Export]
	public Actor _actor;

	public override void OnEnter() {
		_actor.sprite.Play("Die");
		_actor.OnDeath();

		ActorExperience.GrantExperience(_actor);
	}
}