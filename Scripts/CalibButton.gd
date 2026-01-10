extends Sprite3D 

@onready var timer: Timer = $Timer 

@onready var label: Label = $SubViewport/Label
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar

var past_rot: float = 0
var rot_acm: float = 0

signal is_pressed

func _physics_process(_delta: float) -> void:
	var rot: float = self.global_basis.z.dot(Vector3.UP)
	rot_acm += abs(rot - past_rot)
	past_rot = rot
	
	if rot_acm >= 0.1:
		timer.start()
		rot_acm = 0

	progress_bar.value = progress_bar.max_value * clamp((timer.wait_time - timer.time_left) * 2.0 / timer.wait_time -1.0, 0.0, 1.0)


func _on_timer_timeout() -> void:
	timer.start()
	is_pressed.emit()

func disable() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	self.visible = false
	
func enable() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = true
