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

	public void Show(Actor actor, int[] cloakedPerkIds) {
		if (cloakedPerkIds.Length == 0) {
			WaitForOthers();

			return;
		}

		Visible = true;
		_buttonContainer.Visible = true;

		GD.Print($"{Multiplayer.GetUniqueId()} received perks:");

		var index = 0;

		foreach (var cloakedPerkId in cloakedPerkIds) {
			var perk = actor.perks.perkSetups.GetSetup(cloakedPerkId);
			var button = _perkButtons[index++];

			button.Perk(perk);
			button.PerkPressed = () => {
				actor.experience.SelectPerk(perk.CloakedId);
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