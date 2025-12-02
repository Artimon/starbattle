using System.Collections.Generic;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorAvatars : Control {
	public static ActorAvatars instance;

	[Export]
	public PackedScene _avatarPrefab;

	public readonly List<ActorAvatar> _avatars = new ();

	[Export]
	public HBoxContainer _playerAvatarsContainer;

	[Export]
	public HBoxContainer _enemyAvatarsContainer;

	public override void _EnterTree() {
		instance = this;
	}

	public void Add(Actor actor) {
		var avatar = _avatarPrefab.Instantiate<ActorAvatar>();
		avatar.SetActor(actor);

		_avatars.Add(avatar);

		var container = actor.IsPlayerGroup ? _playerAvatarsContainer : _enemyAvatarsContainer;
		container.AddChild(avatar);
	}

	public void Remove(Actor actor) {
		var avatar = _avatars.Find(a => a.Actor == actor);
		if (avatar == null) {
			return;
		}

		_avatars.Remove(avatar);
		avatar.Remove();
	}

	public override void _ExitTree() {
		instance = null;
	}
}