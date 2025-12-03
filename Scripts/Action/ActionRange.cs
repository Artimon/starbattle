using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActionRange : Node3D {
	public Actor _actor;

	[Export]
	public Sprite3D _sprite;

	public override void _Ready() {
		Visible = false;

		_actor = GetParent<Actor>();

		var actionDiameter = _actor.actionRange * 2f;
		var spriteDiameter = _sprite.Texture.GetWidth() * _sprite.PixelSize;
		var scale = actionDiameter / spriteDiameter;

		_sprite.Scale = Vector3.One * scale;
	}
}