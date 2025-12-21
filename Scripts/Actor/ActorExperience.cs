using System.Linq;
using Godot;
using Starbattle.Effects;
using Starbattle.UserInterface.Components;
using Array = System.Array;

namespace Starbattle;

[GlobalClass]
public partial class ActorExperience : Node {
	public int level = 1;

	[Export]
	public Actor _actor;

	public int _openLevelUps;

	public bool HasOpenLevelUps => _openLevelUps > 0;

	public float _experience;

	public float RequiredExperience => level * 3f;

	[Export]
	public PackedScene _levelUpEffectPrefab;

	public static void GrantExperience(Actor defeatedActor) {
		if (defeatedActor.IsPlayerGroup) {
			return;
		}

		var experience = defeatedActor.stats.experience;

		foreach (var actor in Actor.PlayerGroup) {
			actor.experience.Add(experience);
		}
	}

	public void Add(float experience) {
		if (_actor.IsDead) {
			return;
		}

		_experience += experience; // @TODO Maybe multiply by "growth" factor?
		if (_experience < RequiredExperience) {
			ExperienceBar.instance.SetProgress(_experience, RequiredExperience);

			return;
		}

		level += 1;
		_openLevelUps += 1;
		_experience = 0;

		_actor.FullHeal();

		ExperienceBar.instance.SetProgress(_experience, RequiredExperience);
		ExperienceBar.instance.SetLevel(level);

		_levelUpEffectPrefab.Instantiate<LevelUpEffect>(_actor);
	}

	[Rpc(CallLocal = true)]
	public void RpcPerkChoices(int[] cloakedPerkIds, int[] perkRarityIds) {
		var candidates = _actor.perks.perkSetups.ListsToCandidates(cloakedPerkIds, perkRarityIds);

		PerkSelection.instance.Show(_actor, candidates);
	}

	[Rpc(CallLocal = true)]
	public void RpcPauseGame() {
		Engine.TimeScale = 0.0;
	}

	[Rpc(CallLocal = true)]
	public void RpcResumeGame() {
		Engine.TimeScale = 1.0;

		PerkSelection.instance.Hide();
	}

	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
	public void _RpcRequestLevelUp() {
		if (!Multiplayer.IsServer()) {
			return;
		}

		if (!HasOpenLevelUps) {
			return;
		}

		foreach (var actor in Actor.PlayerGroup) {
			// Pause the entire network.
			actor.experience.RpcId(actor.synchronizer.playerId, nameof(RpcPauseGame));

			SendChoices(actor);
		}
	}

	/**
	 * Sends an empty array if there are no open level ups.
	 */
	public void SendChoices(Actor actor) {
		var perkCloakedIds = Array.Empty<int>();
		var perkRarityIds = Array.Empty<int>();

		if (HasOpenLevelUps) {
			var candidates = _actor.perks.RollChoices();

			_actor.perks.perkSetups.CandidatesToLists(candidates, out perkCloakedIds, out perkRarityIds);
		}

		actor.experience.RpcId(actor.synchronizer.playerId, nameof(RpcPerkChoices), perkCloakedIds, perkRarityIds);
	}

	public void SelectPerk(int cloakedPerkId, int rarityId) {
		RpcId(1, nameof(_RpcSelectPerk), cloakedPerkId, rarityId);
	}

	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
	public void _RpcSelectPerk(int cloakedPerkId, int rarityId) {
		if (!Multiplayer.IsServer()) {
			return;
		}

		// Not checking for validity at this moment. Could save the current selection.
		if (HasOpenLevelUps) {
			_actor.perks.Apply(cloakedPerkId, rarityId);
			_openLevelUps -= 1;
		}

		SendChoices(_actor);

		_CheckAllFinished();
	}

	public void _CheckAllFinished() {
		var partyHasOpenLevelUps = Actor.PlayerGroup.Any(actor => actor.experience.HasOpenLevelUps);
		if (partyHasOpenLevelUps) {
			return;
		}

		foreach (var actor in Actor.PlayerGroup) {
			// Continue the entire network.
			actor.experience.RpcId(actor.synchronizer.playerId, nameof(RpcResumeGame));
		}
	}

	public void OnLevelUpPressed() {
		if (!HasOpenLevelUps) {
			return;
		}

		RpcId(1, nameof(_RpcRequestLevelUp));
	}
}