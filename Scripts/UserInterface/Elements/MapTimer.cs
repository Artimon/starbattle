using Godot;
using Starbattle.Controllers;

namespace Starbattle.UserInterface.Elements;

[GlobalClass]
public partial class MapTimer : Label {
	public override void _Process(double delta) {
		var waves = WavesController.instance;
		if (waves == null) {
			return;
		}

		var totalSeconds = (int)waves.Time;
		var minutes = totalSeconds / 60;
		var seconds = totalSeconds % 60;

		Text = $"{minutes}:{seconds:D2}";
	}
}