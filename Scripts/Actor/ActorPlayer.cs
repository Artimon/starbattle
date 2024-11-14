using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorPlayer : ActorBase {
	public static ActorPlayer player;

	public bool isPlayer;

	[Export]
	public Node3D cameraTarget;

	[Export]
	public RayCast3D _rayCast;

	public override void _EnterTree() {
		// Warning: Synchronizer fields are not set yet!

		serverSynchronizer.DeltaSynchronized += () => {
			GD.Print($"DeltaSynchronized: {serverSynchronizer.networkHandle} / {serverSynchronizer.ownerId} ({Multiplayer.GetUniqueId()})");
		};
	}

	public override void _Ready() {
		// Note: Synchronizer fields are set now!

		// Add here, to ensure all synchronizer fields are set.
		ActorContainer.instance.Add(this);

		// GD.Print($"_Ready: {serverSynchronizer.networkHandle} / {serverSynchronizer.ownerId} ({Multiplayer.GetUniqueId()})");

		isPlayer = serverSynchronizer.ownerId == Multiplayer.GetUniqueId();
		if (!isPlayer) {
			return;
		}

		player = this;

		ControllerCamera.instance.Follow(this);
	}

	public override void _ExitTree() {
		ActorContainer.instance.Remove(this);
	}

	public bool _TryGetClickPosition(Vector2 mousePosition, out Vector3 clickPosition, out ActorBase actor) {
		var camera = GetViewport().GetCamera3D();
		var from = camera.ProjectRayOrigin(mousePosition);
		var to = camera.ProjectRayNormal(mousePosition) * 1000f;

		_rayCast.GlobalPosition = from;
		_rayCast.TargetPosition = to;
		_rayCast.ForceRaycastUpdate();

		actor = default;

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
		if (!isPlayer) {
			return;
		}

		if (@event.IsActionPressed("TargetCloser")) {
			TargetMarker.instance.TargetCloser();

			return;
		}

		if (@event.IsActionPressed("TargetFurther")) {
			TargetMarker.instance.TargetFurther();

			return;
		}

		if (@event.IsActionPressed("Move")) {
			_actionType = ActionTypes.Move;

			return;
		}

		if (@event.IsActionPressed("Attack")) {
			Godot.GD.Print($"Current target: {TargetMarker.instance.Target.Name}");
			_actionType = ActionTypes.Attack;
			// stateMachine.

			return;
		}

		if (@event is InputEventMouseButton { Pressed: true } mouseEvent) {
			var success = _TryGetClickPosition(mouseEvent.Position, out var clickPosition, out var actor);
			if (!success) {
				GD.Print($"Failed to get click position");
				return;
			}

			if (actor is ActorMob mob) {
				TargetMarker.instance.Target = mob;

				GD.Print($"Clicked on {mob.Name}");
				return;
			}

			GD.Print($"Clicked at {clickPosition} with {_actionType}");

			if (_actionType == ActionTypes.Move) {
				Rpc(nameof(_MoveTo), clickPosition);
			}

			if (_actionType == ActionTypes.Attack) {
				// Attack
			}
		}
	}
}