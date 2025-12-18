using System.Collections.Generic;
using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class PerkSetups : Resource {
	[Export]
	public PerkSetup[] list;

	public List<PerkSetup> Perks => list.ToList();

	public PerkSetup GetSetup(int cloakedPerkId) {
		var perkId = PerkSetup.RevealId(cloakedPerkId);

		return list.FirstOrDefault(perk => perk.Id == perkId);
	}

	public static float GetWeight(List<PerkSetup> perks) {
		return perks.Sum(perk => perk.Weight);
	}
}