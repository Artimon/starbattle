using System;
using System.Collections.Generic;
using Godot;

namespace Starbattle.UserInterface.Components;

[GlobalClass]
public partial class PerkButton : Button {
	[Export]
	public Label _titleLabel;

	[Export]
	public Label _statsList;

	[Export]
	public CanvasItem[] _rarityElements;

	public Action PerkPressed;

	[Export]
	public string _titleTemplate;

	[Export]
	public string _strengthTemplate;

	[Export]
	public string _dexterityTemplate;

	[Export]
	public string _agilityTemplate;

	[Export]
	public string _vitalityTemplate;

	[Export]
	public string _intelligenceTemplate;

	[Export]
	public string _wisdomTemplate;

	[Export]
	public string _luckTemplate;

	[Export]
	public string _critRateTemplate;

	[Export]
	public string _counterRateTemplate;

	[Export]
	public string _hpRecoveryTemplate;

	[Export]
	public string _spRecoveryTemplate;

	[Export]
	public string _regenerateHpTemplate;

	[Export]
	public string _regenerateSpTemplate;

	[Export]
	public string _physicalBaseValueTemplate;

	[Export]
	public string _magicalBaseValueTemplate;

	[Export]
	public string _physicalDefenseTemplate;

	[Export]
	public string _magicalDefenseTemplate;

	[Export]
	public Color commonColor = Colors.White;

	[Export]
	public Color rareColor = new (0.15f, 0.57f, 0.95f);

	[Export]
	public Color epicColor = new (0.58f, 0.20f, 0.71f);

	[Export]
	public Color legendaryColor = new (0.98f, 0.73f, 0.21f);

	public Dictionary<PerkSetup.Rarities, Color> _rarityColors;

	public override void _EnterTree() {
		_rarityColors = new () {
			{ PerkSetup.Rarities.Common,    commonColor },
			{ PerkSetup.Rarities.Rare,      rareColor },
			{ PerkSetup.Rarities.Epic,      epicColor },
			{ PerkSetup.Rarities.Legendary, legendaryColor },
		};
	}

	public void Perk(PerkSetup setup) {
		foreach (var canvasItem in _rarityElements) {
			canvasItem.Modulate = _rarityColors[setup.rarity];
		}

		_titleLabel.Text = _titleTemplate.Replace("{name}", setup.displayName).Replace("{rarity}", setup.rarity.ToString());

		var stats = setup.stats;
		var statsLines = new List<string>();

		var statTemplatePairs = new (float value, string template)[] {
			(stats.strength, _strengthTemplate),
			(stats.dexterity, _dexterityTemplate),
			(stats.agility, _agilityTemplate),
			(stats.vitality, _vitalityTemplate),
			(stats.intelligence, _intelligenceTemplate),
			(stats.wisdom, _wisdomTemplate),
			(stats.luck, _luckTemplate),
			(stats.critRate, _critRateTemplate),
			(stats.counterRate, _counterRateTemplate),
			(stats.hpRecovery, _hpRecoveryTemplate),
			(stats.spRecovery, _spRecoveryTemplate),
			(stats.regenerateHp, _regenerateHpTemplate),
			(stats.regenerateSp, _regenerateSpTemplate),
			(stats.physicalBaseValue, _physicalBaseValueTemplate),
			(stats.magicalBaseValue, _magicalBaseValueTemplate),
			(stats.physicalDefense, _physicalDefenseTemplate),
			(stats.magicalDefense, _magicalDefenseTemplate),
		};

		foreach (var (value, template) in statTemplatePairs) {
			if (value == 0f) {
				continue;
			}

			var number = ((int)value).ToString();
			statsLines.Add(template.Replace("{value}", number));
		}

		_statsList.Text = string.Join("\n", statsLines);
	}

	public override void _Pressed() {
		GD.Print("Perk clicked: " + _titleLabel.Text);
		PerkPressed?.Invoke();
	}
}