extends RigidBody3D
var pitch_range: float = 0.5
func _ready() -> void:
	$AudioStreamPlayer3D.pitch_scale = 1.0 + randf_range(-pitch_range, pitch_range)
func _process(_delta: float) -> void:
	if self.global_position.z > 200:
		self.free()
