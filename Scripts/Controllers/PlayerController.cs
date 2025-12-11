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

	[Export]
	public uint _targetMask;

	[Export]
	public uint _groundMask;

	public ActionRange _actionRange;

	[Export]
	public PackedScene _actionRangePrefab;

	[Export]
	public ActorSelection _actorSelection;

	public ActionSetup _nextAction;

	public override void _EnterTree() {
		instance = this;
	}

	public void Begin(Actor player) {
		_player = player;
		_actionRange = _actionRangePrefab.Instantiate<ActionRange>(_player);
		_actionRange.Position = Vector3.Up * 0.02f;
	}

	public bool _TryGetClickPosition(Vector2 mousePosition, out Vector3 clickPosition, out Actor actor) {
		var camera = GetViewport().GetCamera3D();
		var from = camera.ProjectRayOrigin(mousePosition);
		var to = camera.ProjectRayNormal(mousePosition) * 1000f;

		_rayCast.CollisionMask = _nextAction.targetType == ActionSetup.TargetTypes.Position ? _groundMask : _targetMask;
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
		var parent = (collider as Node)?.GetParent();
		if (parent is not Actor clickedActor) {
			return true;
		}

		actor = clickedActor;

		// GD.Print($"Detected collision with {actor.Name}");

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

	public void TryRequestAction(Actor actor, Vector3 position) {
		var isRequested = _player.action.TryRequestAction(_nextAction, actor, position);
		if (!isRequested) {
			return; // Allow re-clicking on a correct target without cancelling the action.
		}

		_actionRange.Visible = false;
		_nextAction = null;
	}

	public override void _Input(InputEvent @event) {
		if (@event is InputEventMouseButton { Pressed: true, ButtonIndex: MouseButton.Left } mouseEvent) {
			if (_nextAction == null) {
				return;
			}

			var isHoveringUi = GetViewport().GuiGetHoveredControl() != null;
			if (isHoveringUi) {
				return;
			}

			var hasPosition = _TryGetClickPosition(mouseEvent.Position, out var clickPosition, out var actor);
			if (!hasPosition) {
				GD.Print($"Failed to get click position");
				return;
			}

			// GD.Print($"Clicked target: {actor?.Name ?? "None"} at {clickPosition}");

			TryRequestAction(actor, clickPosition);

			return;
		}

		var nextAction = GetNextAction(@event);
		if (nextAction == null) {
			return;
		}

		_nextAction = nextAction;
		_actionRange.Visible = true;

		var autoTargetsSelf = nextAction.targetType == ActionSetup.TargetTypes.None;
		if (autoTargetsSelf) {
			TryRequestAction(_player, _player.GlobalPosition);

			_actionRange.Visible = false;
			_nextAction = null;

			return;
		}


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

	public ActionSetup GetNextAction(InputEvent @event) {
		if (@event.IsActionPressed("Move")) {
			return _player.setup.playerActions.move;
		}

		if (@event.IsActionPressed("Attack")) {
			return _player.setup.playerActions.attack;
		}

		if (@event.IsActionPressed("RegenerateHits")) {
			return _player.setup.playerActions.regenerateHp;
		}

		if (@event.IsActionPressed("RegenerateMana")) {
			return _player.setup.playerActions.regenerateMp;
		}

		if (@event.IsActionPressed("Q")) {
			return _player.setup.playerActions.q;
		}

		if (@event.IsActionPressed("W")) {
			return _player.setup.playerActions.w;
		}

		if (@event.IsActionPressed("E")) {
			return _player.setup.playerActions.e;
		}

		if (@event.IsActionPressed("R")) {
			return _player.setup.playerActions.r;
		}

		return null;
	}

	public override void _ExitTree() {
		instance = null;
	}
}