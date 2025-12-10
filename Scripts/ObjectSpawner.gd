extends Node3D

var dodge_object_scn: PackedScene = preload("res://Scenes/DodgeObject.tscn")
@onready var timer: Timer = $Timer
@export var speed: float = 80
@export var time: float

func _on_timer_timeout() -> void:
	var object: RigidBody3D = dodge_object_scn.instantiate()
	object.apply_impulse(Vector3(0,0,speed* 1.5))
	object.global_position = self.global_position + Vector3(randi_range(-4, 4), 0, 0)
	self.add_child(object)


func enable() -> void:
	timer.wait_time = time
	timer.start()

func disable() -> void:
	timer.stop()
	for n in get_children():
		if not n is Timer:
			n.free() 
