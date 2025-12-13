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
	public int _currentWave = -1;

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

			_TryProgressWave(0);
			_TrySpawnMobs();

			SetProcess(true);
		};
	}

	public override void _Process(double delta) {
		_TryProgressWave(delta);
	}

	public bool _TryProgressWave(double delta) {
		_time += (float)delta;

		var wave = (int)(_time / 60.0f);
		var isNextWave = wave > _currentWave;

		if (!isNextWave) {
			return false;
		}

		wave = Math.Min(wave, _waveSetups.Length - 1); // @TODO Check for level end here.
		GD.Print($"Now entering wave {wave + 1}");

		_currentWave = wave;
		_waveSetup = _waveSetups[wave];

		// @TODO Spawn boss here.

		return true;
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