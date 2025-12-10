extends Node3D
class_name CameraPivot

var gyroscope: Vector3
var parent: CarboardController

func _ready() -> void:
	parent = self.get_parent()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	if OS.has_feature("mobile"):
		# TODO use gravity to get correct rotation at start
		#self.look_at(Input.get_gravity())
		pass
		

func _process(delta: float) -> void:
	gyroscope = Vector3.ZERO

	if OS.has_feature("pc"):
		# Running debug on pc, use mouse control
		var mouse: Vector2 = Input.get_last_mouse_velocity() * delta * 0.01
		parent.rotate_y(-mouse.x)
		self.rotate_x(-mouse.y)
		self.rotation_degrees.x = clamp(self.rotation_degrees.x, -90, 90)
		
	else:
		# Running on mobile, use gyroscope
		gyroscope = Input.get_gyroscope() * delta
		self.rotate_y(gyroscope.y) # Yaw
		self.rotate_x(gyroscope.x) # Pitch
		self.rotate_z(gyroscope.z) # Roll

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
