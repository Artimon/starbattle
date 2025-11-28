using System.Linq;
using Godot;

namespace Starbattle;

[GlobalClass]
public partial class ActorSetups : Resource {
	[Export]
	public ActorSetup[] setups;

	public ActorSetup GetSetupById(uint setupActorId) {
		return setups.FirstOrDefault(setup => setup.ActorId == setupActorId);
	}
}