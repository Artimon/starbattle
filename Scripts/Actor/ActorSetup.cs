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
	public float pixelHeight;

	public float _spritePixels;

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