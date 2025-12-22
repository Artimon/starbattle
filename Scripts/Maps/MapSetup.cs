using Godot;
using Starbattle.Controllers;

namespace Starbattle.Maps;

[GlobalClass]
public partial class MapSetup : Resource {
	[Export]
	public WaveSetup[] waveSetups;
}