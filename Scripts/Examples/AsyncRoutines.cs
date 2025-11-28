using System.Threading.Tasks;
using Godot;

namespace Artimus.Examples;

public partial class AsyncRoutines : Node {
	public override void _Ready() {
		RunMyRoutine();
	}

	// Async task, works like a Unity Coroutine.
	public async Task RunMyRoutine() {
		GD.Print("Routine started");

		await this.WaitForSeconds(1f);
		GD.Print("1 second passed");

		// Wait for a subroutine (another coroutine).
		await SubRoutine();

		GD.Print("Routine continues");

		var elapsed = 0d;
		var duration = 5d;

		while (elapsed < duration) {
			GD.Print($"Frame: {Engine.GetProcessFrames()} - Elapsed: {elapsed}");
			await this.NextFrame();

			elapsed += GetProcessDeltaTime();
		}

		GD.Print("Done with per-frame loop!");
	}

	public async Task SubRoutine() {
		GD.Print("Subroutine started");

		await this.WaitForSeconds(2f);
		GD.Print("Subroutine ended after 2 seconds");
	}
}