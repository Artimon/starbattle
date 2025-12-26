using Godot;

namespace Artimus.Services;

public static class GlobalTime {
	public static float Seconds => (float)(Time.GetTicksMsec() / 1000d * Engine.TimeScale);
}