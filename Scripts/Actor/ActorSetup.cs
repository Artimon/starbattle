using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorSetup : Resource {
	[Export]
	public string name;

	public uint ActorId => name.Hash();

	[Export]
	public SpriteFrames _animationFrames;

	public SpriteFrames AnimationFrames => _animationFrames;

	[Export]
	public float pixelHeight = 80f; // Should be default and only bigger for larger actors.

	public float _spritePixels;

	[Export]
	public Stats _baseStats;

	public Stats BaseStats => _baseStats.Clone;

	[Export]
	public PlayerActions playerActions;

	[Export]
	public Behaviour behaviour;

	public float GetVitality(float difficulty) {
		return _baseStats.vitality * difficulty * (0.8f + GD.Randf() * 0.4f);
	}

	public float SpritePixels {
		get {
			if (_spritePixels != 0d) {
				return _spritePixels;
			}

			_spritePixels = _animationFrames
				.GetFrameTexture("Idle", 0)
				.GetSize()
				.X;

			return _spritePixels;
		}
	}
}