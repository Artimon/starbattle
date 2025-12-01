using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActionSetups : Resource {
	[Export]
	public ActionSetup[] list;

	public ActionSetup GetSetup(uint actorId) {
		return list.FirstOrDefault(setup => setup.ActionId == actorId);
	}

	public ActionSetup GetSetup(string actorName) {
		return list.FirstOrDefault(setup => setup.name == actorName);
	}
}