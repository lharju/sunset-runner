extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
var gazed_button: ButtonVR
var pre_gazed_button: ButtonVR
func _process(_delta: float) -> void:
	var collider: Object = self.get_collider()
	if collider:
		gazed_button = collider.get_parent() as ButtonVR
		gazed_button.start_gaze()
	elif pre_gazed_button:
		pre_gazed_button.end_gaze()
		pre_gazed_button = null
	
	if pre_gazed_button and pre_gazed_button != gazed_button:
		pre_gazed_button.end_gaze()
		pre_gazed_button = null
	
	pre_gazed_button = gazed_button
