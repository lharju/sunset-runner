extends Node3D


var dodge_object_scn: PackedScene = preload("res://Scenes/DodgeObject.tscn")
@onready var timer: Timer = $Timer
@export var speed: float = 80
@export var time: float

var all_positions: Array = [-4, -3, -2, -1, 0, 1, 2, 3, 4]
var available_positions: Array = []

var curve: Curve = null
var deviation: float = 0.0

func enable(new_speed, new_time) -> void:
	self.speed = new_speed
	self.time = new_time
	
	timer.wait_time = time
	timer.start()

func disable() -> void:
	timer.stop()
	for n in get_children():
		if not n is Timer:
			n.explode(true) 

func _on_timer_timeout() -> void:
	
	if available_positions.size() == 0:
		available_positions = all_positions.duplicate()
		available_positions.shuffle()
		
	var offset = available_positions.pop_front()
		
	var object: CharacterBody3D = dodge_object_scn.instantiate()
	object.curve = curve
	object.deviation = deviation
	object.offset = offset
	
	
	self.add_child(object)
	object.global_position = self.global_position
	object.velocity.z = speed
