using Godot;

namespace Starbattle;

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

	public void FastFlash(float chance = 1f) {
		if (_animationPlayer.IsPlaying()) {
			return;
		}

		if (chance < 1f && GD.Randf() > chance) {
			return;
		}

		_flashRect.Visible = true;
		_animationPlayer.Play("FastFlash");
	}

	public override void _ExitTree() {
		instance = null;
	}
}