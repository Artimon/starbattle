using System;
using Godot;

namespace Artimus.Services;

public abstract partial class StateBase : Node {
	[Export]
	public StateMachine _stateMachine;

	[Export]
	public bool isDefault;

	public string _stateName;

	public string StateName => _stateName ??= GetSimplifiedStateName(GetType());

	public override void _Ready() {
		_stateMachine.Add(this);
	}

	public virtual void OnEnter() { }
	public virtual void OnProcess(double deltaTime) { }
	public virtual void OnExit() { }

	public virtual bool CanExit() {
		return true;
	}

	public static string GetSimplifiedStateName(Type type) => type.Name.Replace("State", "");
}