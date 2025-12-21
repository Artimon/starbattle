using System.Collections.Generic;
using System.Linq;
using Godot;
using Candidate = Starbattle.PerkSetup.Candidate;

namespace Starbattle;

[GlobalClass]
public partial class ActorPerks : Node {
	[Export]
	public Actor _actor;

	[Export]
	public PerkSetups perkSetups;

	public List<Candidate> Candidates => perkSetups.Perks.Select(setup => setup.PickCandidate).ToList();

	public Candidate[] RollChoices() {
		const int picks = 4;

		return Candidates.Shuffle().Take(picks).ToArray();
	}

	public void Apply(int cloakedPerkId, int rarityId) {
		var candidate = perkSetups.GetCandidate(cloakedPerkId, rarityId);

		_actor.stats.Add(candidate.Stats);
	}
}