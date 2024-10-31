using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class Actor : NetworkNode3D {
	public string displayName;

	[Export]
	public Node3D cameraTarget;

	[Export]
	public RayCast3D _rayCast;

	[Export]
	public StateMachine stateMachine;

	[Export]
	public StateMove stateMove;

	// public float inputX;

	public float angle;

	public Vector3 _velocity;
	public Vector3 direction;
	public float moveSpeed;
	public bool isMoving;
	public Vector3 movedBy;

	public bool isMob;

	public bool IsPlayer => !isMob && ownerId == Multiplayer.GetUniqueId();

	public override void _Ready() {
		if (IsPlayer) {
			ControllerCamera.instance.Follow(this);
		}
	}

	public override void _Process(double delta) {
		// _Movement(30f, (float)delta, out isMoving, out movedBy);

		// var velocity = new Vector3(inputX, 0f, 0f) * (float)delta;
		//
		// GlobalPosition += velocity;
	}

	// [Rpc(MultiplayerApi.RpcMode.AnyPeer)]
	// public void _SetInput(float value) {
	// 	inputX = value;
	// }

	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
	public void _MoveTo(Vector3 position) {
		stateMove.MoveTo(position);
	}

	public void _Movement(
		float friction,
		float deltaTime,
		out bool hasMoved,
		out Vector3 movedBy
	) {
		// var velocity = _rigidbody.velocity;
		var velocityChange = Vector3.Zero;
		var velocityTarget = direction.Normalized() * moveSpeed;

		velocityChange.X = (velocityTarget.X - _velocity.X) * friction * deltaTime;
		velocityChange.Z = (velocityTarget.Z - _velocity.Z) * friction * deltaTime;

		_velocity += velocityChange;

		movedBy = _velocity * deltaTime;
		hasMoved = _velocity.ApproximateArea(0.01f);

		GlobalPosition += movedBy;
	}

	public bool _TryGetClickPosition(Vector2 mousePosition, out Vector3 clickPosition) {
		var camera = GetViewport().GetCamera3D();
		var from = camera.ProjectRayOrigin(mousePosition);
		var to = camera.ProjectRayNormal(mousePosition) * 1000f;

		_rayCast.GlobalPosition = from;
		_rayCast.TargetPosition = to;
		_rayCast.ForceRaycastUpdate();

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

	public enum ActionTypes {
		Move,
		Attack
	}

	public ActionTypes _actionType;

	public override void _Input(InputEvent @event) {
		if (!IsPlayer) {
			return;
		}

		if (@event.IsActionPressed("Move")) {
			_actionType = ActionTypes.Move;
		}

		if (@event.IsActionPressed("Attack")) {
			_actionType = ActionTypes.Attack;
		}

		if (@event is InputEventMouseButton { Pressed: true } mouseEvent) {
			var success = _TryGetClickPosition(mouseEvent.Position, out var clickPosition);
			if (!success) {
				GD.Print($"Failed to get click position");
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

		// inputX = Input.GetAxis("Left", "Right");
		//
		// Rpc(nameof(_SetInput), inputX);
	}
}