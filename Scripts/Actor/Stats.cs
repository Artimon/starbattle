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
	public float luck;

	[Export]
	public float critRate;

	[Export]
	public float counterRate;

	[Export]
	public float hpRecovery; // Players only.

	[Export]
	public float spRecovery; // Players only.

	[Export]
	public float regenerateHp;

	[Export]
	public float regenerateSp;

	[Export]
	public float physicalBaseValue;

	[Export]
	public float magicalBaseValue;

	[Export]
	public float physicalDefense;

	[Export]
	public float magicalDefense;

	[Export]
	public float experience;

	/**
	 * @TODO Add 80-120% RNG for mobs.
	 */
	public Stats Clone => Duplicate(true) as Stats;

	public float MaxHp => vitality;
	public float MaxSp => intelligence;

	/**
	 * Critical chances at scale 120:
	 * 5 -> 0,05
	 * 10 -> 0,079
	 * 15 -> 0,117
	 * 50 -> 0,340
	 * 80 -> 0,486
	 * 100 -> 0,565
	 * 120 -> 0,632
	 * 150 -> 0,713
	 * 200 -> 0,811
	 */
	public float CritChance {
		get {
			const float scale = 120f;

			var effectiveCrit = critRate + 0.5f * luck;
			var chance = 1f - Mathf.Exp(-effectiveCrit / scale);

			return Mathf.Clamp(chance, 0.05f, 0.95f);
		}
	}

	public float CounterChance {
		get {
			const float scale = 120f;
			var chance = 1f - Mathf.Exp(-counterRate / scale);

			return Mathf.Clamp(chance, 0.05f, 0.95f);
		}
	}

	public float GetHitChance(Actor target) {
		const float baseChance = 0.85f;

		var total = Mathf.Max(1f, dexterity + target.stats.agility);
		var diff = dexterity - target.stats.agility;

		var hitChance = baseChance + 0.3f * (diff / total);

		return Mathf.Clamp(hitChance, 0.05f, 0.99f);
	}

	public float GetHpRegeneration(float power) {
		return power / 100f * regenerateHp * (1f + GD.Randf() * 0.5f);
	}

	public float GetSpRegeneration(float power) {
		return power / 100f * regenerateSp * (1f + GD.Randf() * 0.5f);
	}

	public float GetPhysicalDamage(float power, Actor target) {
		var attack = power / 100f * physicalBaseValue * (0.5f + strength / 200f) * (1f + GD.Randf() * 0.5f);
		var defense = target.stats.physicalDefense;

		return Mathf.Max(1f, attack - defense);
	}

	public float GetMagicalDamage(float power, Actor target) {
		var attack = power / 100f * magicalBaseValue * (0.5f + wisdom / 200f) * (1f + GD.Randf() * 0.5f);
		var defense = target.stats.magicalDefense;

		return Mathf.Max(1f, attack - defense);
	}

	public void Add(Stats other) {
		strength          += other.strength; // Might
		dexterity         += other.dexterity;
		agility           += other.agility; // Cooldown
		vitality          += other.vitality; // Max Health
		intelligence      += other.intelligence;
		wisdom            += other.wisdom; // Might
		luck              += other.luck; // Luck
		critRate          += other.critRate;
		counterRate       += other.counterRate;
		hpRecovery        += other.hpRecovery; // Recovery
		spRecovery        += other.spRecovery;
		regenerateHp      += other.regenerateHp;
		regenerateSp      += other.regenerateSp;
		physicalBaseValue += other.physicalBaseValue;
		magicalBaseValue  += other.magicalBaseValue;
		physicalDefense   += other.physicalDefense; // Armor
		magicalDefense    += other.magicalDefense;
		// Move Speed
		// Speed (Bullet)
		// Duration (Spells)
		// Area (Spells)
		// Amount (Spells)
		// Revival
		// Magnet
		// Growth
		// Greed
		// Curse
		// Reroll

		GD.Print($" Now adding: {other.strength} strength, {other.dexterity} dexterity, {other.agility} agility, {other.vitality} vitality, {other.intelligence} intelligence, {other.wisdom} wisdom, {other.luck} luck, {other.critRate} critRate, {other.counterRate} counterRate, {other.hpRecovery} hpRecovery, {other.spRecovery} spRecovery, {other.regenerateHp} regenerateHp, {other.regenerateSp} regenerateSp, {other.physicalBaseValue} physicalBaseValue, {other.magicalBaseValue} magicalBaseValue, {other.physicalDefense} physicalDefense, {other.magicalDefense} magicalDefense");
	}
}