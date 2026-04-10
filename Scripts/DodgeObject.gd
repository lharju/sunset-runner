extends RigidBody3D
func _ready() -> void:
	$AudioStreamPlayer3D.pitch_scale = 1.0 + randf_range(-0.1, 0.1)
func _process(_delta: float) -> void:
	if self.global_position.z > 200:
		self.free()
