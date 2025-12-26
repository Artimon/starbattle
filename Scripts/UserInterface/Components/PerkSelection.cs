using Godot;

namespace Starbattle.UserInterface.Components;

[GlobalClass]
public partial class PerkSelection : Panel {
	public static PerkSelection instance;

	[Export]
	public Control _buttonContainer;

	[Export]
	public PerkButton[] _perkButtons;

	public override void _EnterTree() {
		instance = this;
	}

	public override void _Ready() {
		Visible = false;
	}

	public void Show(Actor actor, PerkSetup.Candidate[] candidates) {
		if (candidates.Length == 0) {
			WaitForOthers();

			return;
		}

		Visible = true;
		_buttonContainer.Visible = true;

		var index = 0;

		foreach (var candidate in candidates) {
			var cloakedPerkId = candidate.setup.CloakedId;
			var rarityId = candidate.RarityId;
			var button = _perkButtons[index++];

			button.Perk(candidate);
			button.PerkPressed = () => {
				actor.experience.SelectPerk(cloakedPerkId, rarityId);
			};
		}
	}

	public void WaitForOthers() {
		_buttonContainer.Visible = false;
	}

	public override void _ExitTree() {
		instance = null;
	}
}