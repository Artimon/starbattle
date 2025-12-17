using Godot;

namespace Starbattle.UserInterface.Elements;

[GlobalClass]
public partial class ScreenFlash : Node {
	public static ScreenFlash instance;

	[Export]
	public AnimationPlayer _animationPlayer;

	[Export]
	public ColorRect _flashRect;

	public override void _EnterTree() {
		instance = this;
	}

	public override void _Ready() {
		_flashRect.Visible = false;
	}

	public bool TryFastFlash(float chance = 1f) {
		if (_animationPlayer.IsPlaying()) {
			return false;
		}

		if (chance < 1f && GD.Randf() > chance) {
			return false;
		}

		_flashRect.Visible = true;
		_animationPlayer.Play("FastFlash");

		return true;
	}

	public override void _ExitTree() {
		instance = null;
	}
}