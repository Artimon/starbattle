using Godot;

namespace Starbattle;

[GlobalClass]
public partial class Test : Node3D {
	public override void _Ready() {
		SetProcess(false);
	}

	public override void _Process(double delta) {
		GD.Print("Test Process");
	}
}