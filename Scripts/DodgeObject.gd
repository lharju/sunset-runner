extends CharacterBody3D
class_name DodgeObject

var pitch_range: float = 0.5

@onready var particle_body: CPUParticles3D = $ParticleBody
@onready var particle_tire_front: CPUParticles3D = $ParticleTireFront
@onready var particle_tire_back: CPUParticles3D = $ParticleTireBack

@onready var light_cycle: Node3D = $LightCycle
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


func explode(of: bool):
	if not of:
		self.queue_free()
		return
	light_cycle.hide()

	self.set_physics_process(false)
	particle_body.emitting = true
	particle_tire_back.emitting = true
	particle_tire_front.emitting = true
	
	audio_stream_player_3d.stop()
	await particle_tire_front.finished
	
	self.queue_free()
	

func _ready() -> void:
	audio_stream_player_3d.pitch_scale = 1.0 + randf_range(-pitch_range, pitch_range)
	particle_body.restart()
	particle_tire_back.restart()
	particle_tire_front.restart()
	self.process_mode =Node.PROCESS_MODE_ALWAYS
	self.set_physics_process(true)


	


		
		
func _physics_process(_delta: float) -> void:
	if self.global_position.z > 200:
		explode(false)
		return
	
	
	self.velocity.z = 100
	move_and_slide()
	
	
		
