extends Node3D


@onready var menu: Node3D = $Menu
@onready var grid: MeshInstance3D = $Geometry/Grid
@onready var player: XROrigin3D = $Path3D/PathFollow3D/Player

@onready var object_spawner: Marker3D = $Geometry/ObjectSpawner
@onready var timer: Timer = $Geometry/ObjectSpawner/Timer
@onready var main_music: AudioStreamPlayer = $MainMusic


enum States {NONE = 0 , CALIBRATION = 1, MENU = 2, PLAY = 3}
var game_state: States = States.MENU

var difficulty: int = 0

var score: int = 0
var highscore: ConfigFile
const highscore_path: String = "user://highscores.cfg"


func _ready() -> void:
	highscore = ConfigFile.new()
	
	if FileAccess.file_exists(highscore_path):
		highscore.load(highscore_path)
	else:
		highscore.set_value("highscores", "easy", 0)
		highscore.set_value("highscores", "medium", 0)
		highscore.set_value("highscores", "hard", 0)
		highscore.save(highscore_path)
		
		
	menu.easy.text = str(highscore.get_value("highscores", "easy"))
	menu.medium.text = str(highscore.get_value("highscores", "medium"))
	menu.hard.text = str(highscore.get_value("highscores", "hard"))
		

func _on_xr_origin_3d_is_hit() -> void:
	player.cursor_on = true
	player.next_state = States.MENU
	game_state = States.MENU
	menu.new.hide()
	match difficulty:
		0:
			if score > highscore.get_value("highscores", "easy"):
				menu.easy.text = str(score)
				highscore.set_value("highscores", "easy", score)
				highscore.save(highscore_path)
				menu.new.show()
				menu.new.global_position = menu.easy.global_position + Vector3(0.3, 0, 0)
		1:
			if score > highscore.get_value("highscores", "medium"):
				menu.medium.text = str(score)
				highscore.set_value("highscores", "medium", score)
				highscore.save(highscore_path)
				menu.new.show()
				menu.new.global_position = menu.medium.global_position + Vector3(0.3, 0, 0)
		2:
			if score > highscore.get_value("highscores", "hard"):
				menu.hard.text = str(score)
				highscore.set_value("highscores", "hard", score)
				highscore.save(highscore_path)
				menu.new.show()
				menu.new.global_position = menu.hard.global_position + Vector3(0.3, 0, 0)
	
	object_spawner.disable()
	menu.process_mode = Node.PROCESS_MODE_INHERIT
	menu.show()

func _on_menu_calibrate() -> void:
	player.next_state = States.CALIBRATION
	game_state = States.CALIBRATION
	
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	menu.hide()

func _on_menu_play(_difficulty: int) -> void:
	player.cursor_on = false
	score = 0
	difficulty = _difficulty
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	menu.hide()
	
	player.next_state = States.PLAY
	game_state = States.PLAY
	
	$StartTimer.start()
	await $StartTimer.timeout
	
	object_spawner.speed = 80 + 15 * difficulty
	object_spawner.time = 1.0 - 0.3 * difficulty
	object_spawner.enable()

func _on_player_calibration_done() -> void:
	player.next_state = States.MENU
	menu.process_mode = Node.PROCESS_MODE_INHERIT
	menu.show()

func _on_menu_music(on: bool) -> void:
	if on:
		main_music.play()
	else:
		main_music.stop()

func _on_score_area_body_entered(_body: Node3D) -> void:
	score += 1
