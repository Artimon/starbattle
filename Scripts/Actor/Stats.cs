using Godot;

namespace Starbattle;

// var weaponpDam[4] = 40, 40, 20, 15;	// Weapon basic values for all player classes
// var weaponmDam[4] =  0, 30, 35, 40;
// var armorpDef[4] = 15, 10, 10,  5;	// Armor basic values for all player classes
// var armormDef[4] =  0,  5, 10, 20;

[GlobalClass]
public partial class Stats : Resource {
	/*
	 * ## Options ##
	 * All stats separate:
	 * - Contains "useless" stats for different classes.
	 *
	 * Combine attacks:
	 * - Might/Power for both, less classical feeling.
	 *
	 * Combine atk/def:
	 * - Phys atk/def are one stat, mag atk/def are another.
	 * - Both needed at least for defense, but my feel like wasting one half.
	 * - May feel op to get dmg and resistance at the same time.
	 *
	 * Combine atk/"capacity":
	 * - Str (konstituation, vigor etc.) raises atk/hp.
	 * - Int (wisdom, intelligence etc.) raises mag/sp.
	 * - May feel op to get dmg and hp/sp at the same time.
	 *
	 * ## Additional Hints ##
	 * - The weapon base values can remain separate between phys/mag but then should not be improvable during a run to rpevent splitting up level ups even more. They still modify the damage output, though, to better represent different classes.
	 * - A stat would ideally only have one purpose, to avoid confusion and to make the game more intuitive.
	 * - defense can remain split, because what is needed is defined by the enemies of a stage, not the player class.
	 * - Hybrids should not need too many level ups split up, which would negatively affect their power scaling.
	 * - A pure warrior also uses SP (skill/special points for certain skills), but it may be not too important to level up too much, which is okay.
	 *
	 * STR: Physical ATK (50% for magic)	-> Might
	 * WIS: Magic ATK (50% for physical)	-> Spirit (Arcana/Focus/Willpower)
	 * VIT: Max HP (and only that)			-> Vitality
	 * INT: Max SP (and only that)			-> Wisdom (Mind/Focus/Wisdom/Intellect)
	 * AGI: Speed/ATB (and only that)		-> Agility
	 * DEX: Hit/Evasion (and only that)		-> Dexterity
	 */

	[Export]
	public float might;

	[Export]
	public float spirit;

	[Export]
	public float vitality;

	[Export]
	public float wisdom;

	[Export]
	public float agility;

	[Export]
	public float dexterity;

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
	public float MaxSp => wisdom;

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

		var total = Mathf.Max(1f, dexterity + target.stats.dexterity);
		var diff = dexterity - target.stats.dexterity;

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
		var attack = power / 100f * physicalBaseValue * (0.5f + might / 200f) * (1f + GD.Randf() * 0.5f);
		var defense = target.stats.physicalDefense;

		return Mathf.Max(1f, attack - defense);
	}

	public float GetMagicalDamage(float power, Actor target) {
		var attack = power / 100f * magicalBaseValue * (0.5f + spirit / 200f) * (1f + GD.Randf() * 0.5f);
		var defense = target.stats.magicalDefense;

		return Mathf.Max(1f, attack - defense);
	}

	public void Add(Stats other) {
		might             += other.might; // Might
		dexterity         += other.dexterity;
		agility           += other.agility; // Cooldown
		vitality          += other.vitality; // Max Health
		wisdom            += other.wisdom;
		spirit            += other.spirit; // Might
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

		GD.Print($" Now adding: {other.might} strength, {other.dexterity} dexterity, {other.agility} agility, {other.vitality} vitality, {other.wisdom} intelligence, {other.spirit} wisdom, {other.luck} luck, {other.critRate} critRate, {other.counterRate} counterRate, {other.hpRecovery} hpRecovery, {other.spRecovery} spRecovery, {other.regenerateHp} regenerateHp, {other.regenerateSp} regenerateSp, {other.physicalBaseValue} physicalBaseValue, {other.magicalBaseValue} magicalBaseValue, {other.physicalDefense} physicalDefense, {other.magicalDefense} magicalDefense");
	}
}