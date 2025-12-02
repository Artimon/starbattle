using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorAnimator : Node {
	[Export]
	public Actor _actor;

	[Export]
	public AnimationPlayer _animationPlayer;

	public void FadeIn() {
		_animationPlayer.Play("FadeIn");
	}

	public void FadeOut() {
		_animationPlayer.Play("FadeOut");
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