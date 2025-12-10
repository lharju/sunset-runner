extends CharacterBody3D

func _physics_process(_delta: float) -> void:
	move_and_slide()
	if self.global_position.z >= 200:
		self.free()
