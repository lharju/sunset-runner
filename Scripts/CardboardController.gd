@tool
extends CharacterBody3D
class_name CarboardController

@export_group("Shader Param")
@export var IPD : float = 0.056:
	set(value):
		IPD = value
		if camera_transform_l and camera_transform_r:
			camera_transform_l.position.x = -IPD / 2.0
			camera_transform_r.position.x = IPD / 2.0

@export var eye_scale: float = 1.5:
	set(value):
		eye_scale = value
		if eye_l and eye_r:
			eye_l.material.set_shader_parameter("scale", eye_scale)
			eye_r.material.set_shader_parameter("scale", eye_scale)

@export var eye_barrel: float = 0.2:
	set(value):
		eye_barrel = value
		if eye_l and eye_r:
			eye_l.material.set_shader_parameter("k", eye_barrel)
			eye_r.material.set_shader_parameter("k", eye_barrel)

@export_range(-1.0, +1.0, 0.01) var eye_h_offset: float = 0.0:
	set(value):
		eye_h_offset = value
		if eye_l and eye_r:
			eye_l.material.set_shader_parameter("h_offset", -eye_h_offset)
			eye_r.material.set_shader_parameter("h_offset", eye_h_offset)

@export_range(-1.0, +1.0, 0.01) var eye_v_offset: float = 0.0:
	set(value):
		eye_v_offset = value
		if eye_l and eye_r:
			eye_l.material.set_shader_parameter("v_offset", eye_v_offset)
			eye_r.material.set_shader_parameter("v_offset", eye_v_offset)


@export var eye_offset: Vector2 = Vector2.ZERO:
	set(value):
		eye_offset = value
		if eye_l and eye_r:
			eye_l.material.set_shader_parameter("offset", eye_offset * Vector2(-1.0, 1.0))
			eye_r.material.set_shader_parameter("offset", eye_offset)




@onready var camera_pivot: Node3D = $CameraPivot

@onready var camera_transform_l: RemoteTransform3D = $CameraPivot/CameraTransformL
@onready var camera_transform_r: RemoteTransform3D = $CameraPivot/CameraTransformR

@onready var subview_l: SubViewport = $SubviewL
@onready var subview_r: SubViewport = $SubviewR

@onready var camera_l: Camera3D = $SubviewL/CameraL
@onready var camera_r: Camera3D = $SubviewR/CameraR

@onready var eye_l: TextureRect = $CanvasVR/EyeContainer/EyeL
@onready var eye_r: TextureRect = $CanvasVR/EyeContainer/EyeR
