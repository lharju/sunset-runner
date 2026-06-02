@tool
extends Node3D



@export var animate: bool = false:
	set(new):
		animate = new
		if shader_globals:
			shader_globals.set_deferred("params/road_movement", 1 if animate else 0)
		if not animate:
			_clear_points()
		
@export var curve: Curve = null
@export var point_count: int = 12
@export_tool_button("Clear points") var clear_points: Callable = _clear_points

@onready var shader_globals = $ShaderGlobals
@onready var player = $Player



@export var visual_coeff: float = 4:
	set(new):
		visual_coeff = new
		speed = speed
@export var speed: float = 1.0:
	set(new):
		if shader_globals:
			shader_globals.set_deferred("params/road_speed", speed * visual_coeff)
		speed = new

const rollover: float = 32.0
var time: float = 0.0:
	set(new):
		time = new
		if time >= rollover:
			time -= rollover

func _clear_points():
	if not curve:
		printerr("No curve, unable to init")
		return
	
	curve.clear_points()
	
	for i: int in range(point_count):
		
		var pos: Vector2 = Vector2((i / float(point_count)), 0.5)
		curve.add_point(pos)
		
		pass


func _process(_delta):
	if !animate:
		return
	
	time += _delta 
	shader_globals.set_deferred("params/time", time)
		
	for i: int in range(curve.point_count):
		var pos: Vector2 = curve.get_point_position(i)
		var next_post: Vector2 = pos + Vector2(_delta * speed , 0.0)
		
		if next_post.x > 1.0:
			curve.set_point_value(i, randf_range(0.0, 1.0))
			curve.set_point_offset(i, next_post.x - 1.0)
		else:
			curve.set_point_value(i, next_post.y)
			curve.set_point_offset(i, next_post.x)
			
	

	
	pass
	
	
