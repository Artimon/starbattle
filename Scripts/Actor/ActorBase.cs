using System;
using Artimus.Services;
using Godot;

namespace Starbattle;

/**
 * @link https://godotengine.org/article/multiplayer-in-godot-4-0-scene-replication/
 */
public abstract partial class ActorBase : Node3D {
	public string displayName;

	public enum ActionTypes {
		Idle,
		Move,
		Attack
	}

	public ActionTypes _actionType;

	[Export]
	public CollisionShape3D collisionShape;

	public float Size => collisionShape.Shape.GetMargin();

	[Export]
	public ServerSynchronizer serverSynchronizer;

	[Export]
	public StateMachine stateMachine;

	[Export]
	public StateMove stateMove;

	public Vector3 _velocity;
	public Vector3 direction;
	public float moveSpeed;

	public event Action<ActorBase> OnDeath;

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
}