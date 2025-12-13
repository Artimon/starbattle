using Godot;

namespace Starbattle.Controllers;

[GlobalClass]
public partial class WaveSetup : Resource {
	[Export]
	public int minAmount;

	[Export]
	public ActorSetup[] actors;

	public ActorSetup RandomMobSetup => actors[GD.Randi() % actors.Length];
}