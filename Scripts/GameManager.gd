extends Node3D




@onready var menu: Node3D = $Menu
@onready var grid: MeshInstance3D = $Geometry/Grid
@onready var player: XROrigin3D = $Path3D/PathFollow3D/Player

@onready var object_spawner: Marker3D = $Geometry/ObjectSpawner

@onready var main_music: AudioStreamPlayer = $MainMusic
@onready var shader_globals: ShaderGlobalsOverride = $ShaderGlobals


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
	menu.set_state(1)
		

func _on_xr_origin_3d_is_hit() -> void:
	player.cursor_on = true
	player.next_state = States.MENU
	game_state = States.MENU
	
	menu.set_state(2)
	object_spawner.disable()
	
	menu.your_score.text = str(score)
	menu.new.hide()
	match difficulty:
		0:
			menu.highscore.text = str(highscore.get_value("highscores", "easy"))
			if score > highscore.get_value("highscores", "easy"):
				menu.easy.text = str(score)
				highscore.set_value("highscores", "easy", score)
				highscore.save(highscore_path)
				menu.new.show()
		1:
			menu.highscore.text = str(highscore.get_value("highscores", "medium"))
			if score > highscore.get_value("highscores", "medium"):
				menu.medium.text = str(score)
				highscore.set_value("highscores", "medium", score)
				highscore.save(highscore_path)
				menu.new.show()
		
		2:
			menu.highscore.text = str(highscore.get_value("highscores", "hard"))
			if score > highscore.get_value("highscores", "hard"):
				menu.hard.text = str(score)
				highscore.set_value("highscores", "hard", score)
				highscore.save(highscore_path)
				menu.new.show()
	
	
	
	menu.process_mode = Node.PROCESS_MODE_INHERIT
	menu.show()

func _on_menu_calibrate() -> void:
	player.next_state = States.CALIBRATION
	game_state = States.CALIBRATION
	
	menu.set_state(0)

func _on_menu_play(_difficulty: int = -1) -> void:
	player.cursor_on = false
	score = 0
	if _difficulty != -1:
		difficulty = _difficulty
		
	menu.set_state(0)
	
	player.next_state = States.PLAY
	game_state = States.PLAY
	
	$StartTimer.start()
	await $StartTimer.timeout
	
	object_spawner.enable(80 + 15 * difficulty, 1.0 - 0.3 * difficulty)

func _on_player_calibration_done() -> void:
	player.next_state = States.MENU
	menu.set_state(1)

func _on_menu_music(on: bool) -> void:
	if on:
		main_music.play()
	else:
		main_music.stop()

func _on_score_area_body_entered(_body: Node3D) -> void:
	score += 1

func _on_menu_vection(on: bool) -> void:
	shader_globals.set_deferred("params/road_movement", 0 if on else 1)
	
