using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActionRange : Node3D {
	public Actor _actor;
	public Sprite3D _sprite;

	public override void _EnterTree() {
		Position = new Vector3(0, 0, 0.2f);
		Visible = false;

		var diameter = _actor.actionRange * 2f;
		var spriteSize = _sprite.Texture.GetWidth();
		var scale = diameter / spriteSize;

		_sprite.Scale = Vector3.One * (scale + 0.5f);
	}
}