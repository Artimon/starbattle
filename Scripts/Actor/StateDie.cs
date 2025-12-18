using Artimus.Services;
using Godot;
using Starbattle.Effects;

namespace Starbattle;

[GlobalClass]
public partial class StateDie : StateBase {
	[Export]
	public Actor _actor;

	[Export]
	public AudioStream _dieAudio;

	public override void OnEnter() {
		_actor.sprite.Play("Die");
		_actor.OnDeath();

		ActorExperience.GrantExperience(_actor);

		LocalAudio.Play(_actor.GlobalPosition, _dieAudio);
	}
}