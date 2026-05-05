extends Node3D


@onready var check_box2: CheckBox = $MainMenu/Settings/Music/SubViewport/CheckBox

@onready var easy: Label3D = $MainMenu/Highscores/Easy
@onready var medium: Label3D = $MainMenu/Highscores/Medium
@onready var hard: Label3D = $MainMenu/Highscores/Hard
@onready var new: Sprite3D = $MainMenu/Highscores/New


@onready var title: Sprite3D = $Title
@onready var main_menu: Node3D = $MainMenu


signal play(difficulty: int)
signal calibrate()
signal music(on: bool)
signal vection(on: bool)

var low_vection: bool = false
var music_on: bool = false

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
