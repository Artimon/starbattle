using Godot;

namespace Starbattle;

[GlobalClass]
public partial class PerkSetup : Resource {
	public enum Rarities { Common, Rare, Epic, Legendary }

	// [Flags]
	// public enum Tags {
	// 	None = 0,
	// 	Physical = 1 << 0,
	// 	Magical = 1 << 1,
	// 	Holy = 1 << 2,
	// 	Regen = 1 << 3,
	// 	Defense = 1 << 4,
	// 	Utility = 1 << 5,
	// }

	public uint Id => ResourcePath.Hash();

	[Export]
	public string displayName;

	[Export]
	public Rarities rarity;

	[Export]
	public Stats stats;

	public float Weight => rarity switch {
		Rarities.Common => 1.0f,
		Rarities.Rare => 0.5f,
		Rarities.Epic => 0.15f,
		Rarities.Legendary => 0.05f,
		_ => 1.0f
	};
}