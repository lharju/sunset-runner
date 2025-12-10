extends Node3D

@onready var check_box: CheckBox = $Settings/LowVection/SubViewport/CheckBox
@onready var check_box2: CheckBox = $Settings/Cursor/SubViewport/CheckBox

@onready var easy: Label3D = $Highscores/Easy
@onready var medium: Label3D = $Highscores/Medium
@onready var hard: Label3D = $Highscores/Hard


signal play(difficulty: int)
signal calibrate()
signal vection(low: bool)
signal cursor(on: bool)

var low_vection: bool = false
var cursor_on: bool = true

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


func _on_cursor_is_pressed() -> void:
	cursor_on = !cursor_on
	check_box2.set_pressed_no_signal(cursor_on)
	cursor.emit(cursor_on)
