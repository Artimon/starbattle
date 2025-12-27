using System.Threading.Tasks;
using Godot;

namespace Artimus.Extensions;

public static class NodeExtensions {
	public static void Remove(this Node node) {
#if TOOLS
		var hasParent = node.GetParent() != null;
		if (!hasParent) {
			GD.PrintErr($"Trying to remove a node that was already removed: {node.Name}");

			return;
		}
#endif

		/*
		 * In case this creates a null reference exception, the method has been
		 * called on a node that was already removed from the scene tree.
		 */
		node.GetParent().RemoveChild(node);
		node.QueueFree();
	}

	public static async Task NextFrame(this Node node) {
		await node.ToSignal(node.GetTree(), "process_frame");
	}

	public static async Task WaitForSeconds(this Node node, double seconds) {
		await node.ToSignal(node.GetTree().CreateTimer(seconds), "timeout");
	}

	public static async Task AwaitNextPhysicsFrame(this Node node) {
		await node.ToSignal(node.GetTree(), "physics_frame");
	}
}