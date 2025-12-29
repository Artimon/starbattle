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
	public string description;

	[Export]
	public PerkStats[] stats;

	public bool TryPickRarity(float luck, out Rarities pickedRarity) {
		pickedRarity = Rarities.Common;

		// Luck factor is 2 at 400 luck.
		var luckFactor = Mathf.Min(luck, 400f) / 200f;

		// Do every time, needs to be luck-adjusted anyway.
		var weights = new[] {
			CommonWeight - 0.2f * luckFactor,
			RareWeight + 0.1f * luckFactor,
			EpicWeight + 0.1f * luckFactor,
			LegendaryWeight + 0.05f * luckFactor
		};

		var total = weights.Sum();
		var roll = (float)GD.RandRange(0d, total);

		var cumulative = 0f;

		for (var i = 0; i < weights.Length; i++) {
			cumulative += weights[i];
			if (roll > cumulative) {
				continue;
			}

			var rarity = (Rarities)i;

			if (stats.Any(perk => perk.rarity == rarity)) {
				pickedRarity = rarity;

				return true;
			}

			return false;
		}

		return false;
	}

	public bool TryPickCandidate(float luck, out Candidate candidate) {
		if (TryPickRarity(luck, out var rarity)) {
			candidate = new Candidate {
				setup = this,
				rarity = rarity
			};

			return true;
		}

		candidate = null;

		return false;
	}

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