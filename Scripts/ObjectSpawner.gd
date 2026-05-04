extends Node3D

var dodge_object_scn: PackedScene = preload("res://Scenes/DodgeObject.tscn")
@onready var timer: Timer = $Timer
@export var speed: float = 80
@export var time: float

var all_positions: Array = []
var available_positions: Array = []

func _ready():
	for i in range(-4, 5, 1):
		all_positions.append(i)

func _on_timer_timeout() -> void:
	var object: RigidBody3D = dodge_object_scn.instantiate()
	object.apply_impulse(Vector3(0,0,speed* 1.5))
	
	if available_positions.size() == 0:
		available_positions = all_positions.duplicate()
		available_positions.shuffle()
		
	self.add_child(object)
	object.global_position = self.global_position + Vector3(available_positions.pop_front(), 0, 0)

func enable() -> void:
	timer.wait_time = time
	timer.start()

func disable() -> void:
	timer.stop()
	for n in get_children():
		if not n is Timer:
			n.explode(true) 
