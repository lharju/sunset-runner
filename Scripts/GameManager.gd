@tool
extends Node3D

@onready var shader_globals = $ShaderGlobals
@onready var player = $Player
@onready var object_spawner = $ObjectSpawner
@onready var start_timer = $StartTimer


@export_tool_button("Clear points") var clear_points: Callable = _clear_points
@export var animate: bool = false:
	set(new):
		animate = new
		if shader_globals:
			shader_globals.set_deferred("params/road_movement", 1 if animate else 0)
		if not animate:
			_clear_points()
@export var curve: Curve = null
@export var point_count: int = 12


@export var visual_coeff: float = 4:
	set(new):
		visual_coeff = new
		period = period
@export var period: float = 1.0:
	set(new):
		period = new
		if shader_globals:
			shader_globals.set_deferred("params/road_speed", visual_coeff / (period * 2.0))
@export var road_width: float = 10
@export var road_deviation: float = 10:
	set(new):
		road_deviation = new
		if shader_globals and object_spawner and player:
			object_spawner.deviation = road_deviation
			player.deviation = road_deviation
			shader_globals.set_deferred("params/road_deviation", road_deviation)
	

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
		var x: float = (i / float(point_count))
		var y: float = 0.5 if x > 0.25 else randf()
		var pos: Vector2 = Vector2(x, y)
		curve.add_point(pos)


func play(difficulty: int):
	# Wait a short time before we start
	start_timer.start()
	await start_timer.timeout
	
	# Set parameters that affect the diffculty
	road_deviation = 10
	period = 20 - 4 * difficulty
	point_count = 10 + 5 * difficulty
	
	
	# Enable road
	object_spawner.enable(60 + 10 * difficulty, 1.6 - 0.2 * difficulty)
	animate = true

func stop():
	animate = false
	object_spawner.disable()
	pass

func _ready():
	animate = false
	object_spawner.curve = curve
	object_spawner.deviation = road_deviation

func _process(_delta):
	if !animate:
		return
	
	time += _delta 
	shader_globals.set_deferred("params/time", time)
		
	for i: int in range(curve.point_count):
		var pos: Vector2 = curve.get_point_position(i)
		var next_post: Vector2 = pos + Vector2(_delta / (period * 2.0), 0.0)
		
		if next_post.x > 1.0:
			curve.set_point_value(i, randf_range(0.0, 1.0))
			curve.set_point_offset(i, next_post.x - 1.0)
		else:
			curve.set_point_value(i, next_post.y)
			curve.set_point_offset(i, next_post.x)
