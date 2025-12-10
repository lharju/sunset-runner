extends Node3D


@onready var menu: Node3D = $Menu
@onready var grid: MeshInstance3D = $Geometry/Grid
@onready var player: XROrigin3D = $Path3D/PathFollow3D/Player

@onready var object_spawner: Marker3D = $Geometry/ObjectSpawner
@onready var timer: Timer = $Geometry/ObjectSpawner/Timer


enum States {NONE = 0 , CALIBRATION = 1, MENU = 2, PLAY = 3}
var game_state: States = States.MENU

var _difficulty: int = 0
var _start_time: int = 0

func _on_xr_origin_3d_is_hit() -> void:
	player.next_state = States.MENU
	game_state = States.MENU
	var score: int = int(Time.get_unix_time_from_system()) - _start_time
	match _difficulty:
		0:
			menu.easy.text =  str(score) if score > int(menu.easy.text) else menu.easy.text
		1:
			menu.medium.text =  str(score) if score > int(menu.medium.text) else menu.medium.text
		2:
			menu.hard.text =  str(score) if score > int(menu.hard.text) else menu.hard.text
	
	object_spawner.disable()
	menu.process_mode = Node.PROCESS_MODE_INHERIT
	menu.show()


func _on_menu_calibrate() -> void:
	player.next_state = States.CALIBRATION
	game_state = States.CALIBRATION
	
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	menu.hide()


func _on_menu_play(difficulty: int) -> void:
	_start_time = int(Time.get_unix_time_from_system())
	_difficulty = difficulty
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	menu.hide()
	
	player.next_state = States.PLAY
	game_state = States.PLAY
	
	object_spawner.speed = 60 + 30 * difficulty
	object_spawner.time = 0.8 - 0.2 * difficulty
	object_spawner.enable()

func _on_menu_vection(low: bool) -> void:
	grid.animate = !low

func _on_player_calibration_done() -> void:
	player.next_state = States.MENU
	menu.process_mode = Node.PROCESS_MODE_INHERIT
	menu.show()
	


func _on_menu_cursor(on: bool) -> void:
	player.cursor_on = on
