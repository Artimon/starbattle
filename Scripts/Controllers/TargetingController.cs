using Godot;

namespace Starbattle.Controllers;

[GlobalClass]
public partial class TargetingController : Node {
	public static TargetingController instance;

	public uint GroundMask = 1;
	public uint OpponentMask = 2;
	public uint FriendMask = 4;
	public uint AnyMask = 6;

	public override void _EnterTree() {
		instance = this;
	}

	public uint GetTargetMask(ActionSetup.TargetTypes targetType) {
		return targetType switch {
			ActionSetup.TargetTypes.Position => GroundMask,
			ActionSetup.TargetTypes.Opponent => OpponentMask,
			ActionSetup.TargetTypes.Friend => FriendMask,
			ActionSetup.TargetTypes.None => AnyMask,
			_ => 0
		};
	}

	public uint GetActorMask(Actor actor) {
		return actor.IsPlayerGroup
			? FriendMask
			: OpponentMask;
	}

	public uint GetOpposingMask(Actor actor) {
		return actor.IsPlayerGroup
			? OpponentMask
			: FriendMask;
	}

	public override void _ExitTree() {
		instance = null;
	}
}