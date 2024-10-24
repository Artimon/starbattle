using Artimus.Services;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class Actor : Node3D {
	public string displayName;

	[Export]
	public Node3D cameraTarget;

	[Export]
	public StateMachine stateMachine;

	[Export]
	public StateMove stateMove;

	public int prefabIndex;

	public long ownerId;

	public float inputX;

	public float angle;

	public Vector3 _velocity;
	public Vector3 direction;
	public float moveSpeed;
	public bool isMoving;
	public Vector3 movedBy;

	public bool IsPlayer => ownerId == Multiplayer.GetUniqueId();

	public override void _EnterTree() {
		GD.Print("EnterTree");
	}

	public override void _Ready() {
		GD.Print($"Ready {ownerId} == {Multiplayer.GetUniqueId()} = {IsPlayer}");
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

	[Rpc(MultiplayerApi.RpcMode.AnyPeer)]
	public void _SetInput(float value) {
		inputX = value;
	}

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
		var to = from + camera.ProjectRayNormal(mousePosition) * 1000f;

		var plane = new Plane(Vector3.Up, 0);
		var intersection = plane.IntersectsRay(from, to);

		if (intersection == null) {
			clickPosition = Vector3.Zero;

			return false;
		}

		clickPosition = (Vector3)intersection;

		return true;

	}

	public override void _Input(InputEvent @event) {
		if (!IsPlayer) {
			return;
		}

		if (@event is InputEventMouseButton { Pressed: true } mouseEvent) {
			var success = _TryGetClickPosition(mouseEvent.Position, out var clickPosition);
			if (success) {
				Rpc(nameof(_MoveTo), clickPosition);
			}
		}

		inputX = Input.GetAxis("Left", "Right");

		Rpc(nameof(_SetInput), inputX);
	}
}