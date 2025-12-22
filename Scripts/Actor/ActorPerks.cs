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

	public List<Candidate> Candidates {
		get {
			var candidates = new List<Candidate>();

			foreach (var perkSetup in perkSetups.Perks) {
				var hasRarityCandidate = perkSetup.TryPickCandidate(out var candidate);
				if (hasRarityCandidate) {
					candidates.Add(candidate);
				}
			}

			return candidates;
		}
	}

	public Candidate[] RollChoices() {
		const int picks = 4;

		return Candidates.Shuffle().Take(picks).ToArray();
	}

	public void Apply(int cloakedPerkId, int rarityId) {
		var candidate = perkSetups.GetCandidate(cloakedPerkId, rarityId);

		_actor.stats.Add(candidate.Stats);
	}
}