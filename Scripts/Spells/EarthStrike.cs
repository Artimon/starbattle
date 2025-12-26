using Godot;
using Starbattle.Effects;

namespace Starbattle.Spells;

[GlobalClass]
public partial class EarthStrike : AoeNode {
	[Export]
	public GpuParticles3D _dustParticles;

	[Export]
	public AudioStream _earthStrikeAudio;

	[Export]
	public StoneSpike _spikeInner;

	[Export]
	public StoneSpike _spike1;

	[Export]
	public StoneSpike _spike2;

	[Export]
	public StoneSpike _spike3;

	public override void _Ready() {
		_spikeInner.BeginInner();

		_spike1.BeginOuter(_spikeInner, 0f);
		_spike2.BeginOuter(_spikeInner, 120f);
		_spike3.BeginOuter(_spikeInner, 240f);

		LocalAudio.Play(GlobalPosition, _earthStrikeAudio);
	}

	public void OnSpellActivate() {
		Attack(_actionSetup);
	}

	public void OnEffectFinished() {
		_dustParticles.Emitting = false;
	}

	public void OnRemove() {
		this.Remove();
	}
}