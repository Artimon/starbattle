using System.Globalization;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorAvatar : Control {
	public Actor _actor;

	public Actor Actor => _actor;

	[Export]
	public TextureRect _textureRect;

	[Export]
	public Label _hpLabel;

	[Export]
	public TextureProgressBar _hpBar;

	[Export]
	public TextureProgressBar _atbBar;

	public override void _Process(double delta) {
		UpdateBars();
		MirrorSprite();
	}

	public void UpdateBars() {
		_hpLabel.Text = _actor.hp.ToString(CultureInfo.InvariantCulture);
		_hpBar.MaxValue = _actor.stats.Vitality;
		_hpBar.Value = _actor.hp;

		_atbBar.Value = _actor.action.ActionTime;
	}

	public void SetActor(Actor actor) {
		_actor = actor;

		if (!actor.isPlayer) {
			_atbBar.Visible = false;
		}
	}

	public void MirrorSprite() {
		var sprite = _actor.sprite;

		_textureRect.Texture = sprite.SpriteFrames.GetFrameTexture(
			sprite.Animation,
			sprite.Frame
		);
	}
}