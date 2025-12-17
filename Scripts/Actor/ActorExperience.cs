using Godot;
using Starbattle.Effects;
using Starbattle.UserInterface.Components;

namespace Starbattle;

[GlobalClass]
public partial class ActorExperience : Node {
	public int level = 1;

	[Export]
	public Actor _actor;

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

			// Pause the entire network.
			// if (actor.Multiplayer.IsServer()) {
			// 	actor.experience.RpcId(actor.synchronizer.playerId, nameof(RpcPauseGame));
			// }
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
		_experience = 0;

		ExperienceBar.instance.SetProgress(_experience, RequiredExperience);

		_levelUpEffectPrefab.Instantiate<LevelUpEffect>(_actor);
	}

	[Rpc(CallLocal = true)]
	public void RpcPauseGame() {
		Engine.TimeScale = 0.0;
	}

	[Rpc(CallLocal = true)]
	public void RpcResumeGame() {
		Engine.TimeScale = 1.0;
	}
}