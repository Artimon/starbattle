using Godot;
using Starbattle.Controllers;
using Starbattle.Effects;

namespace Starbattle.Spells;

[GlobalClass]
public partial class ValkyrieFlames : AoeNode {
	[Export]
	public AnimatedSprite3D _sprite;

	[Export]
	public GpuParticles3D _sparkParticles;

	[Export]
	public GpuParticles3D _glowParticles;

	[Export]
	public GpuParticles3D _stoneParticles;

	[Export]
	public AudioStream _spellAudio;

	public override async void _Ready() {
		_sparkParticles.Emitting = true;
		_glowParticles.Emitting = true;

		_sprite.AnimationFinished += () => {
			_sprite.Visible = false;
		};
	}

	public void OnSpellActivate() {
		CameraController.instance.AddTrauma(0.75f);
		LocalAudio.Play(GlobalPosition, _spellAudio);

		_stoneParticles.Emitting = true;

		Attack(_actionSetup);
		Heal();
	}

	private void Heal() {
		if (!Multiplayer.IsServer()) {
			return;
		}

		var heal = _actor.stats.GetHpRegeneration(_actionSetup.power);
		_actor.Heal(heal, true);
	}

	public void OnRemove() {
		this.Remove();
	}
}