using Godot;

namespace Starbattle.Spells;

[GlobalClass]
public partial class HolyLight : AoeNode {
	public readonly FastNoiseLite _noise = new ();

	[Export]
	public OmniLight3D _light;

	public float _lightRange;

	[Export]
	public Sprite3D _lightBeamSprite;

	[Export]
	public AnimationPlayer _animationPlayer;

	[Export]
	public GpuParticles3D _stoneParticles;

	[Export]
	public Timer _shockActivationTimer;

	[Export]
	public Timer _effectDurationTimer;

	public uint _noiseOffset;

	public override void _Ready() {
		_noiseOffset = GD.Randi() % 5000;

		_lightRange = _light.OmniRange;
		_animationPlayer.Play("LightBeam");
	}

	public override void _Process(double delta) {
		var elapsedSeconds = Time.GetTicksMsec() + _noiseOffset;
		var noiseValue = _noise.GetNoise1D(elapsedSeconds * 0.8f);

		var scale = _lightBeamSprite.Scale;
		scale.X = 1f + 0.2f * noiseValue;

		_lightBeamSprite.Scale = scale;
		_light.OmniRange = _lightRange * (1f + 0.5f * noiseValue) * _lightBeamSprite.Modulate.A;
	}

	public void OnSpellActivate() {
		_stoneParticles.Emitting = true;
		_shockActivationTimer.Start();
		_effectDurationTimer.Start();

		MagicAttack(_actionSetup.power);
	}

	public void OnEffectActivate() {
		var flashes = ScreenFlash.instance.TryFastFlash(0.35f);
		if (flashes) {
			CameraController.instance.AddTrauma(0.35f);
		}
	}

	public void OnEffectFinished() {
		_stoneParticles.Emitting = false;
		_shockActivationTimer.Stop();
	}

	public void OnRemove() {
		this.Remove();
	}
}