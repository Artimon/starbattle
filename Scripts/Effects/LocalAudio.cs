using Godot;

namespace Starbattle.Effects;

public partial class LocalAudio : AudioStreamPlayer3D {
	public static void Play(Vector3 globalPosition, AudioStream audioStream, float volume = 1.0f) {
		var player = new LocalAudio();

		EffectContainer.instance.AddChild(player, true);

		player.Bus = "SFX";
		player.Stream = audioStream;
		player.GlobalPosition = globalPosition;
		player.VolumeDb = Mathf.LinearToDb(volume);

		player.Finished += () => player.Remove();
		player.Play();
	}
}