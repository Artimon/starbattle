using Godot;
using Rarities = Starbattle.PerkSetup.Rarities;

namespace Starbattle;

[GlobalClass]
public partial class PerkStats : Stats {
	[Export]
	public Rarities rarity;

	public float Weight => rarity switch {
		Rarities.Common => PerkSetup.CommonWeight,
		Rarities.Rare => PerkSetup.RareWeight,
		Rarities.Epic => PerkSetup.EpicWeight,
		Rarities.Legendary => PerkSetup.LegendaryWeight,
		_ => 1.0f
	};
}