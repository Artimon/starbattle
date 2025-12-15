using Godot;
using Starbattle.Controllers;
using Starbattle.Effects;

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
	public AudioStream _holyLightAudio;

	[Export]
	public AnimationPlayer _animationPlayer;

	[Export]
	public GpuParticles3D _stoneParticles;

	[Export]
	public GpuParticles3D _glowParticles;

	[Export]
	public GpuParticles3D _sparkleParticles;

	[Export]
	public GpuParticles3D _dustParticles;

	[Export]
	public ShockwaveModel _shockwave1;

	[Export]
	public ShockwaveModel _shockwave2;

	[Export]
	public OffsetSprite _offsetSprite;

	[Export]
	public Timer _shockActivationTimer;

	[Export]
	public Timer _effectDurationTimer;

	public uint _noiseOffset;

	public override void _Ready() {
		_noiseOffset = GD.Randi() % 5000;

		_lightRange = _light.OmniRange;
		_animationPlayer.Play("LightBeam");

		LocalAudio.Play(GlobalPosition, _holyLightAudio);
	}

	public override void _Process(double delta) {
		var elapsedSeconds = Time.GetTicksMsec() + _noiseOffset;
		var noiseValue = _noise.GetNoise1D(elapsedSeconds * 0.8f);

		var scale = _lightBeamSprite.Scale;
		scale.X = 1f + 0.2f * noiseValue;

		var alpha = _lightBeamSprite.Modulate.A;

		_lightBeamSprite.Scale = scale;
		_light.OmniRange = _lightRange * alpha;

		_offsetSprite.Alpha = alpha;
	}

	public void OnSpellActivate() {
		_stoneParticles.Emitting = true;
		_glowParticles.Emitting = true;
		_sparkleParticles.Emitting = true;

		_shockwave1.Start();
		_shockwave2.Start(0.5f);

		_shockActivationTimer.Start();
		_effectDurationTimer.Start();

		CameraController.instance.AddTrauma(0.75f);

		Attack(_actionSetup);
	}

	public void OnEffectActivate() {
		// ScreenFlash.instance.TryFastFlash(0.35f);
	}

	public void OnEffectFinished() {
		_stoneParticles.Emitting = false;
		_glowParticles.Emitting = false;
		_sparkleParticles.Emitting = false;
		_dustParticles.Emitting = false;

		_shockwave1.Stop();
		_shockwave2.Stop();

		_shockActivationTimer.Stop();
	}

	public void OnRemove() {
		this.Remove();
	}
}