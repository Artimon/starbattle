using Godot;

namespace Starbattle.Controllers;

/**
 * Receives input and forwards action requests to the server.
 */
public partial class PlayerController : Node {
	public static PlayerController instance;

	public Actor _player;

	[Export]
	public Node3D cameraTarget;

	[Export]
	public RayCast3D _rayCast;

	public override void _EnterTree() {
		instance = this;
	}

	public void Begin(Actor player) {
		_player = player;
	}

	public bool _TryGetClickPosition(Vector2 mousePosition, out Vector3 clickPosition, out Actor actor) {
		var camera = GetViewport().GetCamera3D();
		var from = camera.ProjectRayOrigin(mousePosition);
		var to = camera.ProjectRayNormal(mousePosition) * 1000f;

		_rayCast.GlobalPosition = from;
		_rayCast.TargetPosition = to;
		_rayCast.ForceRaycastUpdate();

		actor = null;

		if (!_rayCast.IsColliding()) {
			clickPosition = Vector3.Zero;

			return false;
		}

		clickPosition = _rayCast.GetCollisionPoint();
		clickPosition.Y = 0f;

		var collider = _rayCast.GetCollider();
		if (collider is not ActorBody3D actorBody) {
			return true;
		}

		actor = actorBody.Actor;

		GD.Print($"Detected collision with {actorBody.Actor.Name}");

		return true;

		// var camera = GetViewport().GetCamera3D();
		// var from = camera.ProjectRayOrigin(mousePosition);
		// var to = from + camera.ProjectRayNormal(mousePosition) * 1000f;
		//
		// var plane = new Plane(Vector3.Up, 0);
		// var intersection = plane.IntersectsRay(from, to);
		//
		// if (intersection == null) {
		// 	clickPosition = Vector3.Zero;
		//
		// 	return false;
		// }
		//
		// clickPosition = (Vector3)intersection;
		//
		// return true;
	}

	public override void _Input(InputEvent @event) {
		// if (!isPlayer) {
		// 	return;
		// }
		//
		// if (@event.IsActionPressed("TargetCloser")) {
		// 	TargetMarker.instance.TargetCloser();
		//
		// 	return;
		// }
		//
		// if (@event.IsActionPressed("TargetFurther")) {
		// 	TargetMarker.instance.TargetFurther();
		//
		// 	return;
		// }
		//
		// if (@event.IsActionPressed("Move")) {
		// 	_actionType = ActionTypes.Move;
		//
		// 	return;
		// }
		//
		// if (@event.IsActionPressed("Attack")) {
		// 	_actionType = ActionTypes.Attack;
		// 	_RequestActionViaRpcId(ActionTypes.Attack, TargetMarker.instance.Target);
		//
		// 	return;
		// }
		//
		// if (@event is InputEventMouseButton { Pressed: true } mouseEvent) {
		// 	var success = _TryGetClickPosition(mouseEvent.Position, out var clickPosition, out var actor);
		// 	if (!success) {
		// 		GD.Print($"Failed to get click position");
		// 		return;
		// 	}
		//
		// 	if (actor is ActorMob mob) {
		// 		TargetMarker.instance.Target = mob;
		//
		// 		GD.Print($"Clicked on {mob.Name}");
		// 		return;
		// 	}
		//
		// 	GD.Print($"Clicked at {clickPosition} with {_actionType}");
		//
		// 	if (_actionType == ActionTypes.Move) {
		// 		_RequestActionViaRpcId(ActionTypes.Move, clickPosition);
		// 	}
		//
		// 	// if (_actionType == ActionTypes.Attack) { }
		// }
	}

	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
	public void _RequestAction(int actionType, Vector3 position, long actorNetworkHandle) {
		if (!Multiplayer.IsServer()) {
			return;
		}

		Rpc(nameof(_CommitAction), actionType, position, actorNetworkHandle);
	}

	[Rpc(CallLocal = true)]
	public void _CommitAction(int actionType, Vector3 position, long actorNetworkHandle) {
		// switch (actionType) {
		// 	case (int)ActionTypes.Move:
		// 		_MoveTo(position);
		// 		break;
		//
		// 	case (int)ActionTypes.Attack:
		// 		_Attack(actorNetworkHandle);
		// 		break;
		// }
	}

	// public void _RequestActionViaRpcId(ActionTypes actionType, ActorBase actor) {
	// 	_RequestActionViaRpcId(actionType, Vector3.Zero, actor);
	// }
	//
	// public void _RequestActionViaRpcId(ActionTypes actionType, Vector3 position, ActorBase actor = null) {
	// 	var networkHandle = actor?.serverSynchronizer.networkHandle ?? 0;
	//
	// 	RpcId(1, nameof(_RequestAction), (int)actionType, position, networkHandle);
	// }

	// public void _Attack(long targetNetworkHandle) {
	// 	var success = ActorContainer.instance.TryGetActor(targetNetworkHandle, out var target);
	// 	if (!success) {
	// 		GD.Print($"Failed to get target with handle {targetNetworkHandle}");
	// 		return;
	// 	}
	//
	// 	GD.Print($"Attacking {target.Name}");
	//
	// 	// @TODO Implement attack logic.
	// }

	public override void _ExitTree() {
		instance = null;
	}
}