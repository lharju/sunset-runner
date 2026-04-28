@tool
extends Node

var android_runtime
var activity
var context

var screen_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	if not OS.has_feature("android"):
		return
	android_runtime = Engine.get_singleton("AndroidRuntime")
	


func get_screen_size() -> Vector2:
	
	if android_runtime:
		activity = android_runtime.getActivity()
		context = android_runtime.getApplicationContext()
				
		var display_metrics = context.getResources().getDisplayMetrics()

		screen_size = Vector2(display_metrics.widthPixels / display_metrics.xdpi, display_metrics.heightPixels / display_metrics.ydpi)

	return screen_size
