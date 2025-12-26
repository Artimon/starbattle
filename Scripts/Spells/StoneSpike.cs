using System.Threading.Tasks;
using Godot;
using Starbattle.Controllers;

namespace Starbattle.Spells;

[GlobalClass]
public partial class StoneSpike : Node3D {
	[Export]
	public Node3D _spike;

	[Export]
	public GpuParticles3D _stoneParticles;

	[Export]
	public AnimationPlayer _animation;

	[Export]
	public Timer _timer;

	public async Task BeginInner() {
		_spike.Rotation = new Vector3(Rotation.X, Mathf.DegToRad(GD.RandRange(0, 360)), Rotation.Z);
		_spike.Scale = Vector3.One * (float)GD.RandRange(1.3, 1.5);

		_timer.WaitTime = 1.75f;
		_timer.Timeout += OnStrikeBegin;
		_timer.Start();

		await ToSignal(_timer, Timer.SignalName.Timeout);

		_timer.WaitTime = 2f;
		_timer.Timeout += OnRetreatBegin;
		_timer.Start();
	}

	public async Task BeginOuter(StoneSpike inner, float angleOffset) {
		var pan = inner.RotationDegrees.Y + angleOffset;
		var position = Vector3.Right * 0.5f;

		_spike.Position = position.Rotated(Vector3.Up, Mathf.RadToDeg(pan));
		_spike.RotationDegrees = new Vector3(
			GD.RandRange(10, 10),
			pan,
			0f
		);

		_spike.Scale = Vector3.One * (float)GD.RandRange(0.9, 1.1);

		_timer.WaitTime = 1f + 0.25f * angleOffset / 120f;
		_timer.Timeout += OnStrikeBegin;
		_timer.Start();

		await ToSignal(_timer, Timer.SignalName.Timeout);

		_timer.WaitTime = 1.5f;
		_timer.Timeout += OnRetreatBegin;
		_timer.Start();
	}

	public void OnStrikeBegin() {
		_animation.Play("Strike");
		_stoneParticles.Emitting = true;
		CameraController.instance.AddTrauma(0.35f);

		_timer.Timeout -= OnStrikeBegin;
	}

	public void OnRetreatBegin() {
		_animation.Play("Retreat");
		_timer.Timeout -= OnRetreatBegin;
	}
}