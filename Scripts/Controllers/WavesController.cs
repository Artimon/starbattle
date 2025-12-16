using System;
using System.Linq;
using Godot;

namespace Starbattle.Controllers;

[GlobalClass]
public partial class WavesController : Node {
	public static int MaxMobs = 10;

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
		wave = Math.Min(wave, _waveSetups.Length - 1); // @TODO Check for level end here.

		var isNextWave = wave > _currentWave;
		if (!isNextWave) {
			return false;
		}

		GD.Print($"Now entering wave {wave + 1}");

		_currentWave = wave;
		_waveSetup = _waveSetups[wave];

		// @TODO Spawn boss here.

		return true;
	}

	public float GetDifficulty() {
		var players = Actor.PlayerGroup;
		if (players.Length == 0) {
			return 1f;
		}

		/*
		 * @TODO Separate wave and player levels in actor setup scale config?
		 */
		var maxLevel = players.Max(actor => actor.experience.level);
		var difficultyFactor = 0.5f + (maxLevel + _currentWave) / 2f; // 0.5 + (1 + 0) / 2 = 1 (100%)

		/*
		 * 1 -> 1.0
		 * 2 -> 1.68
		 * 3 -> 2.28
		 * 4 -> 2.83
		 */
		var partyScale = Mathf.Pow(players.Length, 0.75f);

		return difficultyFactor * partyScale;
	}

	public void _TrySpawnMobs() {
		if (!Multiplayer.IsServer()) {
			return;
		}

		var mobs = Actor.EnemyGroup;
		if (mobs.Length >= MaxMobs) {
			return;
		}

		var difficulty = GetDifficulty();
		var spawnAmount = Mathf.Max(1, _waveSetup.minAmount - mobs.Length);
		while (spawnAmount > 0) {
			spawnAmount -= 1;

			_spawner.CreateMob(ActorSpawner.RandomSpawnPosition, _waveSetup.RandomMobSetup, difficulty);
		}
	}
}