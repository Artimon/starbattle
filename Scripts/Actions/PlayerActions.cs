using Godot;

namespace Starbattle;

[GlobalClass]
public partial class PlayerActions : Resource {
	[Export]
	public ActionSetup move;

	[Export]
	public ActionSetup attack;

	[Export]
	public ActionSetup regenerateHp;

	[Export]
	public ActionSetup regenerateSp;

	[Export]
	public ActionSetup q;

	[Export]
	public ActionSetup w;

	[Export]
	public ActionSetup e;

	[Export]
	public ActionSetup r;
}