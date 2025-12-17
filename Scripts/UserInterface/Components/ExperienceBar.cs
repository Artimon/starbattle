using Godot;

namespace Starbattle.UserInterface.Components;

[GlobalClass]
public partial class ExperienceBar : Control {
	public static ExperienceBar instance;

	[Export]
	public TextureProgressBar _progressBar;

	public override void _EnterTree() {
		instance = this;
	}

	public override void _Ready() {
		_progressBar.Value = 0f;
		_progressBar.MaxValue = 1f;
	}

	public override void _ExitTree() {
		instance = null;
	}

	public void SetProgress(float experience, float requiredExperience) {
		_progressBar.Value = experience;
		_progressBar.MaxValue = requiredExperience;
	}
}