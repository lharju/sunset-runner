extends Node3D

#region onreydy
## GAME MANAGER
@onready var game_manager = $GameManager
@onready var player = $GameManager/Player
@onready var main_music = $GameManager/MainMusic
@onready var start_timer = $GameManager/StartTimer
@onready var shader_globals = $GameManager/ShaderGlobals
## GEOMETRY
@onready var grid: MeshInstance3D = $Geometry/Grid
## MENU
@onready var menu: Node3D = $Menu
#endregion

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

func player_lost() -> void:
	player.cursor_on = true
	player.next_state = States.MENU
	game_state = States.MENU
	
	menu.set_state(2)
	game_manager.stop()
	
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


#region callbacks
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
	
	game_manager.play(difficulty)

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
	shader_globals.set_deferred("params/low_vection", 0 if on else 1)

func _on_player_is_derailed():
	player_lost()

func _on_player_is_hit():
	player_lost()

#endregion
