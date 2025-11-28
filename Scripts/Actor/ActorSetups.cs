using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorSetups : Resource {
	[Export]
	public ActorSetup[] list;

	public ActorSetup GetSetup(uint actorId) {
		return list.FirstOrDefault(setup => setup.ActorId == actorId);
	}

	public ActorSetup GetSetup(string actorName) {
		return list.FirstOrDefault(setup => setup.name == actorName);
	}
}