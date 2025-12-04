using System.Globalization;
using Godot;
using Starbattle.Controllers;

namespace Starbattle;

[GlobalClass]
public partial class ActorAvatar : Control {
	public Actor _actor;

	public Actor Actor => _actor;

	[Export]
	public TextureRect _textureRect;

	[Export]
	public Control _inputArea;

	[Export]
	public Label _hpLabel;

	[Export]
	public AnimatedBar _hpBar;

	[Export]
	public Texture2D _progressBarEnemyTop;

	[Export]
	public Texture2D _progressBarEnemyBottom;

	[Export]
	public TextureProgressBar _atbBar;

	public override void _Ready() {
		_inputArea.GuiInput += OnTextureRectGuiInput;
	}

	public override void _Process(double delta) {
		UpdateBars();
		MirrorSprite();
	}

	public void UpdateBars() {
		_hpLabel.Text = _actor.hp.ToString(CultureInfo.InvariantCulture);
		_hpBar.SetValues(_actor.hp, _actor.stats.Vitality);

		_atbBar.Value = _actor.action.ActionTime;
	}

	public void SetActor(Actor actor) {
		_actor = actor;

		_hpBar.InitValues(_actor.hp, _actor.stats.Vitality);

		if (!actor.isPlayer) {
			_atbBar.Visible = false;
		}

		if (!actor.IsPlayerGroup) {
			_hpBar.SetBars(_progressBarEnemyTop, _progressBarEnemyBottom);
		}
	}

	public void MirrorSprite() {
		var sprite = _actor.sprite;

		_textureRect.Texture = sprite.SpriteFrames.GetFrameTexture(
			sprite.Animation,
			sprite.Frame
		);
	}

	public void OnTextureRectGuiInput(InputEvent @event) {
		if (@event is InputEventMouseButton { Pressed: true, ButtonIndex: MouseButton.Left }) {
			PlayerController.instance.TryRequestAction(_actor, _actor.GlobalPosition);
		}
	}
}