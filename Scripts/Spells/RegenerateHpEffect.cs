using Godot;

namespace Starbattle.Spells;

[GlobalClass]
public partial class RegenerateHpEffect : Node3D {
	[Export]
	public GpuParticles3D _sparkParticles;

	[Export]
	public GpuParticles3D _glowParticles;

	public override void _Ready() {
		_sparkParticles.Emitting = true;
		_glowParticles.Emitting = true;
	}

	public void OnTimerTimeout() {
		this.Remove();
	}
}