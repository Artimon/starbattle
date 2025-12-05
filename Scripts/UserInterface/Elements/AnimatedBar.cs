using Godot;

namespace Starbattle;

[GlobalClass]
public partial class AnimatedBar : Control {
	[Export] public TextureProgressBar _topBar;
	[Export] public TextureProgressBar _bottomBar;

	public TextureProgressBar _animatedBar;
	public float _targetValue;

	public override void _Process(double delta) {
		var deltaProgress = _animatedBar.MaxValue * 0.35f * (float)delta;

		_animatedBar.Value = Mathf.MoveToward(_animatedBar.Value, _targetValue, deltaProgress);
	}

	public void InitValues(float value, float maxValue) {
		_topBar.Value = value;
		_topBar.MaxValue = maxValue;
		_bottomBar.Value = value;
		_bottomBar.MaxValue = maxValue;
	}

	public void SetValues(float value, float maxValue) {
		if (value == _targetValue) {
			return;
		}

		if (value < _topBar.Value) {
			_topBar.Value = value;
			_animatedBar = _bottomBar;
		}
		else {
			_bottomBar.Value = value;
			_animatedBar = _topBar;
		}

		_topBar.MaxValue = maxValue;
		_bottomBar.MaxValue = maxValue;
		_targetValue = value;
	}

	public void SetBars(Texture2D topProgress, Texture2D bottomProgress) {
		_topBar.TextureProgress = topProgress;
		_bottomBar.TextureProgress = bottomProgress;
	}
}