extends Node3D

@onready var check_box: CheckBox = $A/Settings/LowVection/SubViewport/CheckBox
@onready var check_box2: CheckBox = $A/Settings/Music/SubViewport/CheckBox

@onready var easy: Label3D = $A/Highscores/Easy
@onready var medium: Label3D = $A/Highscores/Medium
@onready var hard: Label3D = $A/Highscores/Hard


signal play(difficulty: int)
signal calibrate()
signal vection(low: bool)
signal music(on: bool)

var low_vection: bool = false
var music_on: bool = false

func _on_calibrate_is_pressed() -> void:
	calibrate.emit()

func _on_low_vection_is_pressed() -> void:
	low_vection = !low_vection
	check_box.set_pressed_no_signal(low_vection)
	vection.emit(low_vection)

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
