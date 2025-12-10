extends MobileVRInterface
class_name CardBoardVR


func _init() -> void:
	var interface: XRInterface = XRServer.find_interface("Native mobile")
	if interface and interface.initialize():
		get_viewport().use_xr = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
