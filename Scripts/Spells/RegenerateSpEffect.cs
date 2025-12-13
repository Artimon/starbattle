using Godot;

namespace Starbattle.Spells;

[GlobalClass]
public partial class RegenerateSpEffect : Node3D {
	[Export]
	public GpuParticles3D _sparkParticles;

	[Export]
	public GpuParticles3D _glowParticles;

	[Export]
	public GpuParticles3D _streakParticles;

	public override void _Ready() {
		_sparkParticles.Emitting = true;
		_glowParticles.Emitting = true;
		_streakParticles.Emitting = true;
	}

	public void OnTimerTimeout() {
		this.Remove();
	}
}