using System.Collections.Generic;
using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class PerkSetups : Resource {
	[Export]
	public PerkSetup[] items;

	public List<PerkSetup> Perks => items.ToList();

	public PerkSetup GetSetup(int cloakedPerkId) {
		var perkId = PerkSetup.RevealId(cloakedPerkId);

		return items.FirstOrDefault(perk => perk.Id == perkId);
	}

	public static float GetWeight(List<PerkSetup> perks) {
		return perks.Sum(perk => perk.Weight);
	}
}