using Godot;
using Starbattle.Effects;

namespace Starbattle.Spells;

[GlobalClass]
public partial class RegenerateSpEffect : Node3D {
	[Export]
	public GpuParticles3D _sparkParticles;

	[Export]
	public GpuParticles3D _glowParticles;

	[Export]
	public GpuParticles3D _streakParticles;

	[Export]
	public AudioStream _regenerateAudio;

	public override void _Ready() {
		_sparkParticles.Emitting = true;
		_glowParticles.Emitting = true;
		_streakParticles.Emitting = true;

		LocalAudio.Play(GlobalPosition, _regenerateAudio);
	}

	public void OnTimerTimeout() {
		this.Remove();
	}
}