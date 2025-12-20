using System;
using Godot;

namespace Starbattle.UserInterface.Components;

[GlobalClass]
public partial class PerkButton : Button {
	[Export]
	public Label _titleLabel;

	[Export]
	public Label _rarityLabel;

	public Action PerkPressed;

	public void Perk(PerkSetup setup) {
		_titleLabel.Text = setup.displayName;
		_rarityLabel.Text = setup.rarity.ToString();
	}

	public override void _Pressed() {
		GD.Print("Perk clicked: " + _titleLabel.Text);
		PerkPressed?.Invoke();
	}
}