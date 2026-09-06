extends XROrigin3D

@export_group("Calibration")
@export var display_to_lens: float = 4.0
@export var display_width: float = 14.5
@export var eye_height: float = 1.6
@export var iod: float = 6.0
@export var k1: float = 0.215
@export var k2: float = 0.215
@export var oversample: float = 1.5

@export_group("Movement")
@export var velocity: float = 4.0
@export var deviation: float = 10.0
@export var curve: Curve = null




@onready var camera_3d: Camera3D = $Camera3D
@onready var xr_camera_3d: XRCamera3D = $XRCamera3D

@onready var gaze_raycast: RayCast3D = $GazeRaycast
@onready var calib_button: Sprite3D = $GazeRaycast/CalibButton

@onready var cursor: Sprite3D = $GazeRaycast/Cursor




var interface: MobileVRInterface
enum States {NONE = 0 , CALIBRATION = 1, MENU = 2, PLAY = 3}
var game_state: States = States.NONE
var next_state: States = States.NONE
var cal_state: int = 0
var cal_next: bool = false
var cursor_on: bool = true:
	set(value):
		cursor_on = value
		cursor.visible = value

signal is_hit()
signal is_derailed()
signal calibration_done()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if OS.has_feature("pc"):
		camera_3d.current = true
		gaze_raycast.reparent(camera_3d)
		xr_camera_3d.free()
		#calibration_image.hide()
	else:
		xr_camera_3d.current = true
		gaze_raycast.reparent(xr_camera_3d)
		camera_3d.free()
		interface = XRInterfaceManager.interface

func _physics_process(delta: float) -> void:
	if OS.has_feature("pc"):
		#Running on pc emulate controls
		var mouse_input: Vector2 = -Input.get_last_mouse_velocity() * delta
		var roll_input: float = - Input.get_axis("roll_left", "roll_right")
		camera_3d.rotate_x(mouse_input.y * 0.01)
		camera_3d.rotation_degrees.z = move_toward(camera_3d.rotation_degrees.z, 45 * roll_input, 90 * delta)
		self.rotate_y(mouse_input.x * 0.01)
		
		
		
	var pitch: float = gaze_raycast.global_basis.z.dot(Vector3.UP)
	var roll: float = gaze_raycast.global_basis.y.dot(Vector3.RIGHT)


	## Handle player state transitions
	match next_state:
		States.NONE:
			pass
		States.CALIBRATION:
			game_state = next_state
			calib_button.enable()
			cal_state = 0
			cal_next = false
		States.MENU:
			calib_button.disable()
			game_state = next_state
		States.PLAY:
			calib_button.disable()
			game_state = next_state
	
	next_state = States.NONE
		
	
	match game_state:
		States.CALIBRATION:
			if OS.has_feature("pc"):
				## running on pc, skip calibration
				
				calibration_done.emit()
				return
				
			if cal_next:
				cal_state += 1
				cal_next = false
				
			match (cal_state):
				0:
					interface.display_width = display_width + pitch * 4.0
					calib_button.label.text = "width\n%2.2f" % interface.display_width
				1:
					interface.iod = iod + pitch * 1.5
					calib_button.label.text = "iod\n%1.3f" % interface.iod
				2:
					interface.k1 = k1 + pitch * 0.2
					calib_button.label.text = "k1\n%1.3f" % interface.k1
				3:
					interface.k2 = k2 + pitch * 0.2
					calib_button.label.text = "k2\n%1.3f" % interface.k2
				_:
					XRInterfaceManager.save_properties()
					calibration_done.emit()
		States.PLAY:
			position.x += roll * delta * velocity
			## TODO, handle derailing
			var s: float = (curve.sample(0.5) * 2.0 - 1.0) * deviation
			if self.global_position.x < -5 + s or self.global_position.x > 5 + s:
				AndroidManager.vibrate()
				position.x = 0
				is_derailed.emit()
			
		States.MENU:
			
			position.x = move_toward(position.x, 0.0, delta * 0.25)

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_calib_button_is_pressed() -> void:
	cal_next = true

func _on_area_3d_body_entered(_body: Node3D) -> void:
	_body.explode(false)
	AndroidManager.vibrate()
	position.x = 0
	is_hit.emit()
