@tool
extends Node

var interface: MobileVRInterface = null
var config: ConfigFile = null

const config_path: String = "user://xr_interface_properties.cfg" 

func save_properties():
	config = ConfigFile.new()
	config.set_value("config", "display_to_lens", interface.display_to_lens)
	config.set_value("config", "display_width", interface.display_width)
	config.set_value("config", "iod", interface.iod)
	config.set_value("config", "k1", interface.k1)
	config.set_value("config", "k2", interface.k2)
	config.save(config_path)
	
func load_properties():
	config = ConfigFile.new()
	config.load(config_path)
	interface.display_to_lens	= config.get_value("config", "display_to_lens", 4.0)
	interface.display_width		= config.get_value("config", "display_width", 14.5)
	interface.iod				= config.get_value("config", "iod", 1.85)
	interface.k1				= config.get_value("config", "k1", 0.215)
	interface.k2				= config.get_value("config", "k2", 0.215)
	

func _ready() -> void:
	# If running in the editor, skip creating the XR interface
	if OS.has_feature("pc"):
		return
	if OS.has_feature("android"):
		pass
	if OS.has_feature("iOS"):
		return
	# Testing file access
	# OS.request_permissions()
	

	
	
	# Init the XR interface
	interface = XRServer.find_interface("Native mobile") as MobileVRInterface
	interface.initialize()
	if interface and interface.initialize():
		get_viewport().use_xr = true
	else:
		# HACK should handle failure to init interface
		return
		
	

	# Load config file if it exists, else create it with default values 
	if FileAccess.file_exists(config_path):
		load_properties()
	else:
		save_properties()
	
		
