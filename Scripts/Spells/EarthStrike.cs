using Godot;
using Starbattle.Controllers;

namespace Starbattle.Spells;

[GlobalClass]
public partial class EarthStrike : AoeNode {
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
	}

	public void OnSpellActivate() {
		CameraController.instance.AddTrauma(0.75f);

		Attack(_actionSetup);
	}
}