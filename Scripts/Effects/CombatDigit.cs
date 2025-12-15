using Godot;

[GlobalClass]
public partial class CombatDigit : Label3D {
	public const float BounceTime = 0.3f; // Set in animator.
	public const float BounceHeight = 0.4f;

	public const float PauseTime = 1f;

	public const float FadeTime = 0.25f;
	public const float FadeHeight = 0.15f;

	public float _timer;
	public float _phaseTime;
	public int _phase;
	public float _fadeOutTime;

	public Vector3 _originalPosition;
	private Color _originalModulate;

	public override void _Ready() {
		SetProcess(false);
	}

	public void Begin(float delay, float maxDelay) {
		_timer = -delay;
		_fadeOutTime = BounceTime + maxDelay + PauseTime - delay;

		_originalPosition = Position;
		_originalModulate = Modulate;

		SetProcess(true);
	}

	public override void _Process(double delta) {
		_timer += (float)delta;
		if (_timer < 0f) {
			return;
		}

		switch (_phase) {
			case 0:
				if (_timer < BounceTime) {
					var progress = _timer / BounceTime;
					var up = Mathf.Sin(progress * Mathf.Pi) * BounceHeight;

					Position = _originalPosition + new Vector3(0f, up, 0f);
				}
				else {
					Position = _originalPosition;

					_phase = 1;
					_phaseTime = 0f;
				}

				break;

			case 1:
				_phaseTime += (float)delta;
				if (_phaseTime > PauseTime) {
					_phase = 2;
					_phaseTime = 0f;
				}

				break;

			case 2:
				if (_timer < _fadeOutTime) {
					return;
				}

				_phaseTime += (float)delta;

				var moveProgress = Mathf.Clamp(_phaseTime / FadeTime, 0f, 1f);
				if (moveProgress > 1.0f) {
					this.Remove();

					return;
				}

				Position = _originalPosition + new Vector3(0f, -FadeHeight * moveProgress, 0f);

				var color = _originalModulate;
				color.A = 1.0f - moveProgress;
				Modulate = color;

				var outlineColor = OutlineModulate;
				outlineColor.A = color.A;
				OutlineModulate = outlineColor;

				break;
		}
	}
}
