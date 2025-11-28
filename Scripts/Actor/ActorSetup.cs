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

	public float _spriteSize;

	public float SpriteSize {
		get {
			if (_spriteSize != 0d) {
				return _spriteSize;
			}

			_spriteSize = _animationFrames
				.GetFrameTexture("Idle", 0)
				.GetSize()
				.X;

			return _spriteSize;
		}
	}
}