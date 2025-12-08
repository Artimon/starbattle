using Godot;

namespace Starbattle.Spells;

[GlobalClass]
public partial class HolyLight : Node3D {
	public readonly FastNoiseLite _noise = new ();

	[Export]
	public OmniLight3D _light;

	public float _lightRange;

	[Export]
	public Sprite3D _lightBeamSprite;

	[Export]
	public AnimationPlayer _animationPlayer;

	public float _timer;

	public override void _Ready() {
		_lightRange = _light.OmniRange;
		_animationPlayer.Play("LightBeam");
	}

	public override void _Process(double delta) {
		_timer += (float)delta;
		if (_timer > 0.2f) {
			_timer -= 0.2f;

			var flashes = ScreenFlash.instance.TryFastFlash(0.35f);
			if (flashes) {
				CameraController.instance.AddTrauma(0.35f);
			}
		}

		var elapsedSeconds = Time.GetTicksMsec();
		var noiseValue = _noise.GetNoise1D(elapsedSeconds * 0.8f);

		var scale = _lightBeamSprite.Scale;
		scale.X = 1f + 0.2f * noiseValue;

		_lightBeamSprite.Scale = scale;
		_light.OmniRange = _lightRange * (1f + 0.5f * noiseValue) * _lightBeamSprite.Modulate.A;
	}
}