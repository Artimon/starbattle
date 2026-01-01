using Godot;

namespace Starbattle.UserInterface.Components;

[GlobalClass]
public partial class ScreenEffects : Control {
	public static ScreenEffects instance;

	[Export]
	public WorldEnvironment _worldEnvironment;

	[Export]
	public ColorRect _vignette;

	[Export(PropertyHint.Range, "0.1,10")]
	public float _fadeSpeed = 5f;

	public float _percent = 1f;
	public float _saturation;
	public float _opacity;

	public ShaderMaterial _vignetteMaterial;

	public override void _EnterTree() {
		instance = this;
	}

	public override void _Ready() {
		_vignetteMaterial = (ShaderMaterial)_vignette.Material;
	}

	public override void _Process(double delta) {
		_UpdateEffect(delta);
	}

	public void _UpdateEffect(double delta) {
		var targetSaturation = _percent < 0.25f ? 0f : 1f;
		var targetOpacity = _percent < 0.4f ? 1f : 0f;

		_saturation = Mathf.Lerp(_saturation, targetSaturation, (float)delta * _fadeSpeed);
		_opacity = Mathf.Lerp(_opacity, targetOpacity, (float)delta * _fadeSpeed);

		_vignetteMaterial.SetShaderParameter("opacity", _opacity);
		_vignetteMaterial.SetShaderParameter("saturation", _saturation);
		_worldEnvironment.Environment.AdjustmentSaturation = _saturation;
	}

	public void SetHealth(Actor actor) {
		var percent = actor.hp / actor.MaxHp;

		_percent = Mathf.Clamp(percent, 0f, 1f);
	}

	public override void _ExitTree() {
		instance = null;
	}
}