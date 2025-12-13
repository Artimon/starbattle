using System;
using Godot;

namespace Starbattle.Controllers;

[GlobalClass]
public partial class WavesController : Node {
	public static int MaxMobs = 20;

	[Export]
	public MultiplayerContainer _multiplayerContainer;

	[Export]
	public Timer _timer;

	public float _time;
	public int _lastWave = -1;

	public WaveSetup _waveSetup;

	[Export]
	public WaveSetup[] _waveSetups;

	[Export]
	public ActorSpawner _spawner;

	public override void _Ready() {
		SetProcess(false);

		_multiplayerContainer.OnConnectionReady += () => {
			if (!Multiplayer.IsServer()) {
				return;
			}

			_timer.Start();

			_OnNewWave(0);
			_TrySpawnMobs();

			SetProcess(true);
		};
	}

	public override void _Process(double delta) {
		_time += (float)delta;

		var waveMinute = (int)(_time / 60.0f);
		if (waveMinute > _lastWave) {
			_lastWave = waveMinute;

			_OnNewWave(waveMinute);
		}
	}

	public void _OnNewWave(int wave) {
		wave = Math.Min(wave, _waveSetups.Length - 1); // @TODO Check for level end here.
		GD.Print($"Now entering wave {wave + 1}");

		_waveSetup = _waveSetups[wave];

		// @TODO Spawn boss here.
	}

	public void _TrySpawnMobs() {
		if (!Multiplayer.IsServer()) {
			return;
		}

		var mobs = Actor.Mobs;
		if (mobs.Length >= MaxMobs) {
			return;
		}

		var spawnAmount = Mathf.Max(1, _waveSetup.minAmount - mobs.Length);
		while (spawnAmount > 0) {
			spawnAmount -= 1;

			_spawner.CreateMob(ActorSpawner.RandomSpawnPosition, _waveSetup.RandomMobSetup);
		}
	}
}