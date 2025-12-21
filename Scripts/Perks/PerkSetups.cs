using System.Collections.Generic;
using System.Linq;
using Godot;
using Candidate = Starbattle.PerkSetup.Candidate;

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

	public Candidate GetCandidate(int cloakedPerkId, int perkRarityId) {
		var perkId = PerkSetup.RevealId(cloakedPerkId);
		var perk = items.FirstOrDefault(perk => perk.Id == perkId);

		return new Candidate {
			setup = perk,
			rarity = (PerkSetup.Rarities)perkRarityId
		};
	}

	public void CandidatesToLists(Candidate[] candidates, out int[] perkCloakedIds, out int[] perkRarityIds) {
		perkCloakedIds = candidates.Select(candidate => candidate.setup.CloakedId).ToArray();
		perkRarityIds = candidates.Select(candidate => (int)candidate.rarity).ToArray();
	}

	public Candidate[] ListsToCandidates(int[] cloakedPerkIds, int[] perkRarityIds) {
		var candidates = new Candidate[cloakedPerkIds.Length];

		for (var i = 0; i < cloakedPerkIds.Length; i++) {
			candidates[i] = new Candidate {
				setup = GetSetup(cloakedPerkIds[i]),
				rarity = (PerkSetup.Rarities)perkRarityIds[i]
			};
		}

		return candidates;
	}
}