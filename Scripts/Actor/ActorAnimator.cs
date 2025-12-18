using Godot;
using Starbattle.Controllers;
using Starbattle.Effects;

namespace Starbattle;

[GlobalClass]
public partial class ActorAnimator : Node {
	[Export]
	public Actor _actor;

	[Export]
	public AnimationPlayer _animationPlayer;

	[Export]
	public AudioStream _hitAudio;

	public void FadeIn() {
		_animationPlayer.Play("FadeIn");
	}

	public void FadeOut() {
		_animationPlayer.Play("FadeOut");
	}

	public void Hit(float damage) {
		_animationPlayer.Play("Hit");

		LocalAudio.Play(_actor.GlobalPosition, _hitAudio);

		if (!_actor.isPlayer) {
			return;
		}

		var trauma = 0.2f + damage / _actor.MaxHp;
		CameraController.instance.AddTrauma(trauma);
	}

	public void OnAnimationFinished(StringName animationName) {
		switch (animationName) {
			case "FadeIn":
				_actor.action.SetProcess(true); // ATB begins.

				break;

			case "FadeOut":
				if (Multiplayer.IsServer()) {
					_actor.Remove();
				}

				break;
		}
	}
}