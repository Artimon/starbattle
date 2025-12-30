using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorSynchronizer : MultiplayerSynchronizer {
	[Export]
	public Actor _actor;

	[Export]
	public uint handle; // Network-wide unique identifier.

	[Export]
	public int playerId;

	[Export]
	public uint actorId;

	[Export]
	public Vector3 spawnPosition;

	[Export]
	public float spawnActionTime;

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

	public override void _Process(double delta) {
		if (actorId == 0) {
			return;
		}

		SyncStats();
	}

	public void SyncStats() {
		_actor.stats.might = might;
		_actor.stats.spirit = spirit;
		_actor.stats.vitality = vitality;
		_actor.stats.wisdom = wisdom;
		_actor.stats.agility = agility;
		_actor.stats.dexterity = dexterity;
		_actor.stats.luck = luck;
		_actor.stats.critRate = critRate;
		_actor.stats.counterRate = counterRate;
		_actor.stats.hpRecovery = hpRecovery;
		_actor.stats.spRecovery = spRecovery;
		_actor.stats.regenerateHp = regenerateHp;
		_actor.stats.regenerateSp = regenerateSp;
		_actor.stats.physicalBaseValue = physicalBaseValue;
		_actor.stats.magicalBaseValue = magicalBaseValue;
		_actor.stats.physicalDefense = physicalDefense;
		_actor.stats.magicalDefense = magicalDefense;
	}

	public void AddStats(Stats other) {
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

	public void SetBaseStats(Stats baseStats, float difficulty = 1f) {
		var isPlayerGroup = _actor.IsPlayerGroup;

		if (!isPlayerGroup) {
			spawnActionTime = GD.Randf(); // Up to 1 of 3 bars.
		}

		might = Stats.Modify(baseStats.might, isPlayerGroup);
		spirit = Stats.Modify(baseStats.spirit, isPlayerGroup);
		vitality = Stats.Modify(baseStats.vitality, isPlayerGroup, difficulty);
		wisdom = Stats.Modify(baseStats.wisdom, isPlayerGroup);
		agility = Stats.Modify(baseStats.agility, isPlayerGroup);
		dexterity = Stats.Modify(baseStats.dexterity, isPlayerGroup);
		luck = Stats.Modify(baseStats.luck, isPlayerGroup);
		critRate = Stats.Modify(baseStats.critRate, isPlayerGroup);
		counterRate = Stats.Modify(baseStats.counterRate, isPlayerGroup);
		hpRecovery = Stats.Modify(baseStats.hpRecovery, isPlayerGroup);
		spRecovery = Stats.Modify(baseStats.spRecovery, isPlayerGroup);
		regenerateHp = Stats.Modify(baseStats.regenerateHp, isPlayerGroup);
		regenerateSp = Stats.Modify(baseStats.regenerateSp, isPlayerGroup);
		physicalBaseValue = Stats.Modify(baseStats.physicalBaseValue, isPlayerGroup);
		magicalBaseValue = Stats.Modify(baseStats.magicalBaseValue, isPlayerGroup);
		physicalDefense = Stats.Modify(baseStats.physicalDefense, isPlayerGroup);
		magicalDefense = Stats.Modify(baseStats.magicalDefense, isPlayerGroup);
	}
}