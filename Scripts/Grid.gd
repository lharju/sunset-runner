@tool
extends MeshInstance3D

@export var speed: float = 10
@export var animate: bool = true

var acc: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	if animate:
		acc -= Vector3(0, speed, 0) * delta 
		self.material_override.uv1_offset = acc
