using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorShake : Node3D {
	[Export]
	public Actor _actor;

	public double _duration;

	public override void _Process(double deltaTime) {
		var progress = 5.5f * GlobalTime.Seconds;

		_actor.sprite.Position = new Vector3(
			Mathf.Cos(progress * 5f) * 0.01f,
			Mathf.Sin(progress * 2f) * 0.01f,
			Mathf.Cos(progress * 5f) * 0.01f
		);

		_duration -= deltaTime;
		if (_duration > 0d) {
			return;
		}

		_actor.sprite.Position = Vector3.Zero;

		SetProcess(false);
	}

	public void Play() {
		_duration = 0.5625f; // Same as in StateHit.

		SetProcess(true);
	}
}