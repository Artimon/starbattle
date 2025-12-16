using Godot;
using Starbattle.Effects;

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
		}
	}

	public void Add(float experience) {
		_experience += experience; // @TODO Maybe multiply by "growth" factor?
		if (_experience < RequiredExperience) {
			return;
		}

		_levelUpEffectPrefab.Instantiate<LevelUpEffect>(_actor);
	}
}