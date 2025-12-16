using Godot;

namespace Starbattle.Effects;

[GlobalClass]
public partial class LevelUpEffect : Node3D {
	[Export]
	public AnimatedSprite3D _sprite;

	[Export]
	public GpuParticles3D[] _particleEffects;

	[Export]
	public AudioStream _levelUpAudio;

	public override void _Ready() {
		_sprite.AnimationFinished += OnAnimationFinished;

		foreach (var effect in _particleEffects) {
			effect.Restart();
		}

		LocalAudio.Play(GlobalPosition, _levelUpAudio);
	}

	public void OnTimeout() {
		this.Remove();
	}

	public void OnAnimationFinished() {
		_sprite.Visible = false;
	}
}