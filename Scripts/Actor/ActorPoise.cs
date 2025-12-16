using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorPoise : Node {
	public const float PoiseThreshold = 0.3f;
	public const double PoiseDecay = 0.1f;
	public const double StaggerDecay = 0.1f;

	public const float ImmunityDuration = 1f;

	[Export]
	public Actor _actor;

	public float _poise;
	public float _staggers;
	public float _immunityTimer;

	public override void _Process(double delta) {
		_poise = Mathf.Max(0f, _poise - (float)(PoiseDecay * delta));
		_staggers = Mathf.Max(0f, _staggers - (float)(StaggerDecay * delta));

		_immunityTimer -= (float)delta;
	}

	// Call in your damage routine:
	public void ApplyPoise(float damage, out bool isStaggered) {
		isStaggered = false;

		if (_immunityTimer > 0f) {
			return;
		}

		var staggerFactor = 1f / (_staggers + 1f);

		/*
		 * Normal enemies should go down in 2-3 hits.
		 * Poise buildup should thus be about 3 times the relative gap to trigger instant stagger on enemies.
		 */
		var poiseBuildup = damage / _actor.MaxHp * staggerFactor;

		_poise += poiseBuildup;
		if (_poise < PoiseThreshold) {
			return;
		}

		_poise = 0f;
		_staggers += 1f;
		_immunityTimer = ImmunityDuration;

		isStaggered = true;
	}
}
