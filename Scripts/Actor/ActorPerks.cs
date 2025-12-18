using System.Collections.Generic;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorPerks : Node {
	public Actor _actor;

	[Export]
	public PerkSetups perkSetups;

	public override void _Ready() {
		// var choices = RollChoices();
		//
		// GD.Print("--------------");
		//
		// foreach (var perkSetup in choices) {
		// 	GD.Print($"Rolling perk setup {perkSetup.ResourcePath}");
		// }
	}

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
}