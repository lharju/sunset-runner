@tool
extends Sprite3D
class_name ButtonVR

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
@onready var label: Label = $SubViewport/Label

@export_multiline var text: String = "":
	set(value):
		text = value
		if label:
			label.text = value

var is_gazed: bool = false
signal is_pressed

func start_gaze() -> void:
	if is_gazed == false:
		timer.start()
		is_gazed = true

func end_gaze() -> void:
	if is_gazed == true:
		timer.stop()
		progress_bar.value = 0
		is_gazed = false

func _process(_delta: float) -> void:
	if is_gazed:
		progress_bar.value = progress_bar.max_value * (timer.wait_time - timer.time_left) / timer.wait_time

func _on_timer_timeout() -> void:
	is_pressed.emit()
