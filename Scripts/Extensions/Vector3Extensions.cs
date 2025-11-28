using Godot;

namespace Artimus.Extensions;

public static class Vector3Extensions {
	public static bool ApproximateArea(this Vector3 vector, float range) {
		return (
			Mathf.Abs(vector.X) <= range &&
			Mathf.Abs(vector.Y) <= range &&
			Mathf.Abs(vector.Z) <= range
		);
	}
}