using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorSelection : Node3D {
	public static ActorSelection instance;

	public Actor _actor;

	public Actor Actor => _actor;

	[Export]
	public Sprite3D sprite;

	public override void _EnterTree() {
		instance = this;
		sprite.Visible = false;
	}

	public void SetActor(Actor actor) {
		if (actor == null) {
			ClearActor();

			return;
		}

		GD.Print("Vis");

		if (_actor == actor) {
			return;
		}

		GetParent().RemoveChild(this);

		_actor = actor;
		_actor.AddChild(this);

		sprite.Visible = true;

		Scale = Vector3.One * _actor.setup.SpritePixels / 300f;
		GD.Print($"New scale: {Scale}");

		// Position = Vector3.Zero;
	}

	public void ClearActor() {
		GD.Print("Invis");
		sprite.Visible = false;
		_actor = null;
	}

	public override void _ExitTree() {
		instance = null;
	}
}