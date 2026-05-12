using System;
using System.Linq;
using Godot;
using Starbattle.Maps;

namespace Starbattle.Controllers;

[GlobalClass]
public partial class WavesController : Node {
	public const int MaxMobs = 10;

	public static WavesController instance;

	[Export]
	public MultiplayerContainer _multiplayerContainer;

	[Export]
	public Timer _timer;

	public float _time;
	public float Time => _time;

	public int _currentWave = -1;

	public bool _spawnPause;

	public WaveSetup _waveSetup;

	[Export]
	public MapSetup _mapSetup;

	[Export]
	public ActorSpawner _spawner;

	public override void _EnterTree() {
		instance = this;
	}

	public override void _Ready() {
		SetProcess(false);

		_multiplayerContainer.OnConnectionReady += () => {
			SetProcess(true);

			if (!Multiplayer.IsServer()) {
				// Only clients need to request the time.
				RpcId(1, nameof(_RpcRequestTime));

				return;
			}

			_timer.Start();

			_TryProgressWave();
			_TrySpawnMobs();
		};
	}

	public override void _Process(double delta) {
		_time += (float)delta;

		if (Multiplayer.IsServer()) {
			_TryProgressWave();
		}
	}

	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
	public void _RpcRequestTime() {
		RpcId(Multiplayer.GetRemoteSenderId(), nameof(_RpcTimeUpdate), _time);
	}

	[Rpc(CallLocal = true)]
	public void _RpcTimeUpdate(float time) {
		_time = time;
	}

	public bool _TryProgressWave() {
		var wave = (int)(_time / 60.0f);
		wave = Math.Min(wave, _mapSetup.waveSetups.Length - 1); // @TODO Check for level end here.

		var isNextWave = wave > _currentWave;
		if (!isNextWave) {
			return false;
		}

		GD.Print($"Now entering wave {wave + 1}");

		_currentWave = wave;
		_waveSetup = _mapSetup.waveSetups[wave];
		_spawnPause = true; // Skip one spawn cycle to give players time to recover.

		_TrySpawnBosses(_waveSetup.bosses);

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
		var difficultyFactor = 0.75f + _currentWave / 4f; // 0.5 + (1 + 0) / 2 = 1 (100%)

		/*
		 * 1 -> 1.0
		 * 2 -> 1.68
		 * 3 -> 2.28
		 * 4 -> 2.83
		 */
		var partyScale = Mathf.Pow(players.Length, 0.75f);

		return difficultyFactor * partyScale;
	}

	public void _TrySpawnBosses(ActorSetup[] bossSetups) {
		if (bossSetups == null) {
			return;
		}

		if (!Multiplayer.IsServer()) {
			return;
		}

		var difficulty = GetDifficulty();

		foreach (var setup in bossSetups) {
			_spawner.CreateMob(ActorSpawner.RandomSpawnPosition, setup, difficulty);
		}
	}

	public void _TrySpawnMobs() {
		if (!Multiplayer.IsServer()) {
			return;
		}

		if (_spawnPause) {
			_spawnPause = false;

			return;
		}

		var spawnAmount = _waveSetup.minAmount - Actor.EnemyGroup.Length;
		if (spawnAmount <= 0) {
			return; // Still has full wave size.
		}

		var difficulty = GetDifficulty();

		var maxGroupSize = Mathf.FloorToInt(_waveSetup.minAmount * 0.7f);
		spawnAmount = Mathf.Min(spawnAmount, maxGroupSize);

		while (spawnAmount > 0) {
			spawnAmount -= 1;

			_spawner.CreateMob(ActorSpawner.RandomSpawnPosition, _waveSetup.RandomMobSetup, difficulty);
		}
	}

	public override void _ExitTree() {
		instance = null;
	}
}