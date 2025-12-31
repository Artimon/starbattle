using Godot;
using System.Collections.Generic;

namespace Starbattle.Effects;

public partial class LocalAudio : AudioStreamPlayer3D {
	public static HashSet<AudioStream> _soundsPlayedThisFrame = new();
	public static ulong _lastFrame;

	public static void Play(Vector3 globalPosition, AudioStream audioStream, float volume = 1.0f) {
		var currentFrame = Engine.GetProcessFrames();
		if (_lastFrame != currentFrame) {
			_lastFrame = currentFrame;
			_soundsPlayedThisFrame.Clear();
		}

		if (!_soundsPlayedThisFrame.Add(audioStream)) {
			return;
		}

		var player = new LocalAudio();

		EffectContainer.instance.AddChild(player, true);

		player.Bus = "SFX";
		player.Stream = audioStream;
		player.GlobalPosition = globalPosition;
		player.VolumeDb = Mathf.LinearToDb(volume);

		player.Finished += () => player.Remove();
		player.PitchScale = (float)GD.RandRange(0.9, 1.1);
		player.Play();
	}
}