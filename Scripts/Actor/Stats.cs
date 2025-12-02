using Godot;

namespace Starbattle;

[GlobalClass]
public partial class Stats : Resource {
	[Export] public int Strength { get; set; }
	[Export] public int Dexterity { get; set; }
	[Export] public int Agility { get; set; }
	[Export] public int Vitality { get; set; }
	[Export] public int Intelligence { get; set; }
	[Export] public int Wisdom { get; set; }

	/**
	 * @TODO Add 80-120% RNG for mobs.
	 */
	public Stats Clone => new () {
		Strength = Strength,
		Dexterity = Dexterity,
		Agility = Agility,
		Vitality = Vitality,
		Intelligence = Intelligence,
		Wisdom = Wisdom
	};
}