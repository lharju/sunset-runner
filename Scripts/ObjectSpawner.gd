extends Node3D

@export var dodge_object_scn: PackedScene = null
@onready var timer: Timer = $Timer
@export var speed: float = 0
@export var time: float

func _on_timer_timeout() -> void:
	var object: CharacterBody3D = dodge_object_scn.instantiate()
	self.add_child(object)
	object.velocity.z = speed
	object.global_position = self.global_position + Vector3(randi_range(-4, 4), 0, 0)


func enable() -> void:
	timer.wait_time = time
	timer.start()

func disable() -> void:
	timer.stop()
	for n in get_children():
		if not n is Timer:
			n.free() 
