using Godot;
using Starbattle.Controllers;

namespace Starbattle.Spells;

[GlobalClass]
public partial class ValkyrieFlames : AoeNode {
	[Export]
	public AnimatedSprite3D _sprite;

	[Export]
	public GpuParticles3D _sparkParticles;

	[Export]
	public GpuParticles3D _glowParticles;

	public override async void _Ready() {
		_sparkParticles.Emitting = true;
		_glowParticles.Emitting = true;

		_sprite.AnimationFinished += () => {
			_sprite.Visible = false;
		};
	}

	public void OnSpellActivate() {
		CameraController.instance.AddTrauma(0.75f);

		Attack(_actionSetup);
	}

	public void OnRemove() {
		this.Remove();
	}
}