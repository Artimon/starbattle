using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class StateIdle : StateBase {
	[Export]
	public Actor _actor;

	public override string StateName => "Idle";

	public override void OnEnter() {
		_actor.sprite.Animation = "Idle";
		_actor.sprite.Frame = 0;
	}
}