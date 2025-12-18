using System.Linq;
using Godot;
using Starbattle.Effects;
using Starbattle.UserInterface.Components;

namespace Starbattle;

[GlobalClass]
public partial class ActorExperience : Node {
	public int level = 1;

	[Export]
	public Actor _actor;

	public int _openLevelUps;

	public bool HasOpenLevelUps => _openLevelUps > 0;

	public float _experience;

	public float RequiredExperience => level * 5f;

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
	public void RpcPerkChoices(int[] cloakedPerkIds) {
		GD.Print($"{Multiplayer.GetUniqueId()} received perks:");

		foreach (var cloakedPerkId in cloakedPerkIds) {
			var perk = _actor.perks.perkSetups.GetSetup(cloakedPerkId);
			GD.Print($"Perk: {perk.ResourcePath}");
		}
	}

	[Rpc(CallLocal = true)]
	public void RpcPauseGame() {
		Engine.TimeScale = 0.0;
	}

	[Rpc(CallLocal = true)]
	public void RpcResumeGame() {
		Engine.TimeScale = 1.0;
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

			// Send choices.
			var perkIds = _actor.perks
				.RollChoices()
				.Select(perk => perk.CloakedId)
				.ToArray();

			actor.experience.RpcId(actor.synchronizer.playerId, nameof(RpcPerkChoices), perkIds);
		}
	}

	public void OnLevelUpPressed() {
		if (!HasOpenLevelUps) {
			return;
		}

		RpcId(1, nameof(_RpcRequestLevelUp));
	}
}