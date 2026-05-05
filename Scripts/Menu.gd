extends Node3D


@onready var check_box2: CheckBox = $MainMenu/Settings/Music/SubViewport/CheckBox

@onready var easy: Label3D = $MainMenu/Highscores/Easy
@onready var medium: Label3D = $MainMenu/Highscores/Medium
@onready var hard: Label3D = $MainMenu/Highscores/Hard

@onready var new: Sprite3D = $ReplayMenu/New
@onready var your_score: Label3D = $ReplayMenu/YourScore
@onready var highscore: Label3D = $ReplayMenu/Highscore


@onready var title: Node3D = $Title
@onready var main_menu: Node3D = $MainMenu
@onready var replay_menu: Node3D = $ReplayMenu


signal play(difficulty: int)
signal calibrate()
signal music(on: bool)
signal vection(on: bool)

var low_vection: bool = false
var music_on: bool = false



func set_state(state: int) -> void:
	match state:
		0: # Hide Menu
	
			title.hide()
			main_menu.hide()
			main_menu.process_mode = Node.PROCESS_MODE_DISABLED
			replay_menu.hide()
			replay_menu.process_mode = Node.PROCESS_MODE_DISABLED
		1: # Main Menu
			title.show()
			main_menu.show()
			main_menu.process_mode = Node.PROCESS_MODE_INHERIT
			replay_menu.hide()
			replay_menu.process_mode = Node.PROCESS_MODE_DISABLED
		2: # Again Menu
			title.hide()
			main_menu.hide()
			main_menu.process_mode = Node.PROCESS_MODE_DISABLED
			replay_menu.show()
			replay_menu.process_mode = Node.PROCESS_MODE_INHERIT
			
			
			

func _on_calibrate_is_pressed() -> void:
	calibrate.emit()

func _on_play_easy_is_pressed() -> void:
	play.emit(0)

func _on_play_medium_is_pressed() -> void:
	play.emit(1)

func _on_play_hard_is_pressed() -> void:
	play.emit(2)

func _on_music_is_pressed() -> void:
	music_on = !music_on
	check_box2.set_pressed_no_signal(music_on)
	music.emit(music_on)

func _on_vection_is_pressed() -> void:
	low_vection = !low_vection
	vection.emit(low_vection)

func _on_play_again_is_pressed() -> void:
	play.emit(-1)

func _on_back_to_menu_is_pressed() -> void:
	set_state(1)
