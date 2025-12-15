using Godot;
using Starbattle.Controllers;

namespace Starbattle;

[GlobalClass]
public partial class CombatNumberBounce : Node3D {
	[Export]
	public Timer _delayTimer;

	[Export]
	public PackedScene _digitPrefab;

	[Export]
	public Color _damageColor;

	[Export]
	public Color _criticalColor;

	[Export]
	public Color _healColor;

	[Export]
	public Color _refreshColor;

	public float _timer;

	public override void _EnterTree() {
		SetProcess(false);
	}

	public override void _Process(double delta) {
		Rotation = CameraController.instance.Rotation;

		_timer += (float)delta;
		if (_timer > 4f) {
			this.Remove();
		}
	}

	public void ShowHeal(Actor actor, float number) {
		ShowNumber(actor, number, _healColor);
	}

	public void ShowDamage(Actor actor, float number, bool isCritical, int hitCount) {
		if (hitCount == 0) {
			ShowNumber(actor, number, isCritical ? _criticalColor : _damageColor);

			return;
		}

		var zeroCount = hitCount - 1;
		var sharpness = 4f;
		var weight = zeroCount / (zeroCount + sharpness);
		var delay = Mathf.Lerp(0.1f, 0.3f, weight);

		_delayTimer.WaitTime = delay;
		_delayTimer.Timeout += () => {
			ShowNumber(actor, number, isCritical ? _criticalColor : _damageColor);
		};
		_delayTimer.Start();
	}

	public void ShowRefresh(Actor actor, float number) {
		ShowNumber(actor, number, _refreshColor);
	}

	private void ShowNumber(Actor actor, float number, Color color) {
		var numberString = Mathf.Clamp(Mathf.RoundToInt(number), 0, 9999).ToString();
		var count = numberString.Length;

		var digitSpacing = 0.3f;
		var totalWidth = (count - 1) * digitSpacing;
		var startX = -totalWidth / 2f;

		var digitDelay = 0.1f;
		var maxDelay = digitDelay * (count - 1);

		for (var i = 0; i < count; i++) {
			var digitChar = numberString[i];
			var digit = _digitPrefab.Instantiate<CombatDigit>(this);

			digit.Text = digitChar.ToString();
			digit.Modulate = color;
			digit.Position = new Vector3(startX + i * digitSpacing, 0, 0);

			digit.Begin(i * digitDelay, maxDelay);
		}

		var position = actor.GlobalCenter + Vector3.Up * 0.25f * actor.Height;
		position.X += GD.Randf() * 1f - 0.5f;
		position.Y += GD.Randf() * 1f - 0.5f;
		position.Z += GD.Randf() * 1f - 0.5f;

		GlobalPosition = position;

		SetProcess(true);
	}
}