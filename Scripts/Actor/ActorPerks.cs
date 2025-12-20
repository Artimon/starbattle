using System.Collections.Generic;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorPerks : Node {
	[Export]
	public Actor _actor;

	[Export]
	public PerkSetups perkSetups;

	public PerkSetup[] RollChoices() {
		const int picks = 3;
		var availablePerks = perkSetups.Perks;
		var choices = new List<PerkSetup>();

		for (var i = 0; i < picks && availablePerks.Count > 0; i++) {
			var remainingWeight = PerkSetups.GetWeight(availablePerks);
			var roll = GD.RandRange(0d, remainingWeight);

			var cumulative = 0d;

			foreach (var perk in availablePerks) {
				cumulative += perk.Weight;

				if (roll > cumulative) {
					continue;
				}

				choices.Add(perk);
				availablePerks.Remove(perk);

				break;
			}
		}

		return choices.ToArray();
	}

	public void Apply(int cloakedPerkId) {
		var perk = perkSetups.GetSetup(cloakedPerkId);

		_actor.stats.Add(perk.stats);
	}
}