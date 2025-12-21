using System;
using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class PerkSetup : Resource {
	public const float CommonWeight = 0.5f;
	public const float RareWeight = 0.35f;
	public const float EpicWeight = 0.1f;
	public const float LegendaryWeight = 0.05f;

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

	public int CloakedId => unchecked((int)Id);

	[Export]
	public string displayName;

	[Export]
	public PerkStats[] stats;

	public Rarities PickRarity {
		get {
			var total = stats.Sum(s => s.Weight);
			var roll = GD.RandRange(0d, total);

			var cumulative = 0d;

			foreach (var perkStats in stats) {
				cumulative += perkStats.Weight;

				if (roll > cumulative) {
					continue;
				}

				return perkStats.rarity;
			}

			throw new Exception($"No rarity found for perk setup {displayName}");
		}
	}

	public Candidate PickCandidate => new() {
		setup = this,
		rarity = PickRarity
	};

	public static uint RevealId(int cloakedId) {
		return unchecked((uint)cloakedId);
	}

	public class Candidate {
		public PerkSetup setup;
		public Rarities rarity;

		public int RarityId => (int)rarity;

		public PerkStats Stats {
			get {
				foreach (var perkStats in setup.stats) {
					if (perkStats.rarity == rarity) {
						return perkStats;
					}
				}

				throw new Exception($"No stats found for rarity {rarity} in perk setup {setup.displayName}");
			}
		}
	}
}