using Godot;

namespace Starbattle;

// var weaponpDam[4] = 40, 40, 20, 15;	// Weapon basic values for all player classes
// var weaponmDam[4] =  0, 30, 35, 40;
// var armorpDef[4] = 15, 10, 10,  5;	// Armor basic values for all player classes
// var armormDef[4] =  0,  5, 10, 20;

[GlobalClass]
public partial class Stats : Resource {
	[Export]
	public float strength;

	[Export]
	public float dexterity;

	[Export]
	public float agility;

	[Export]
	public float vitality;

	[Export]
	public float intelligence;

	[Export]
	public float wisdom;

	[Export]
	public float regenerateHp;

	[Export]
	public float regenerateMp;

	[Export]
	public float physicalBaseValue;

	[Export]
	public float magicalBaseValue;

	[Export]
	public float physicalDefense;

	[Export]
	public float magicalDefense;

	/**
	 * @TODO Add 80-120% RNG for mobs.
	 */
	public Stats Clone => Duplicate(true) as Stats;

	public float GetHpRegeneration(float power) {
		return power * regenerateHp * (1f + GD.Randf() * 0.5f);
	}

	public float GetMpRegeneration(float power) {
		return power * regenerateMp * (1f + GD.Randf() * 0.5f);
	}

	public float GetPhysicalDamage(float power, Actor target) {
		var attack = power * physicalBaseValue * (0.5f + strength / 200f) * (1f + GD.Randf() * 0.5f);
		var defense = target.stats.physicalDefense;

		return Mathf.Max(1f, attack - defense);
	}

	public float GetMagicalDamage(float power, Actor target) {
		var attack = power * magicalBaseValue * (0.5f + wisdom / 200f) * (1f + GD.Randf() * 0.5f);
		var defense = target.stats.magicalDefense;

		return Mathf.Max(1f, attack - defense);
	}
}