@tool
extends Node

var interface: MobileVRInterface = null
var config: ConfigFile = null

const config_path: String = "user://xr_interface_properties.cfg" 

func save_properties():
	config.set_value("config", "display_to_lens", interface.display_to_lens)
	config.set_value("config", "display_width", interface.display_width)
	config.set_value("config", "iod", interface.iod)
	config.set_value("config", "k1", interface.k1)
	config.set_value("config", "k2", interface.k2)
	config.save(config_path)
	
func load_properties():
	interface.display_to_lens	= config.get_value("config", "display_to_lens")
	interface.display_width		= config.get_value("config", "display_width")
	interface.iod				= config.get_value("config", "iod")
	interface.k1				= config.get_value("config", "k1")
	interface.k2				= config.get_value("config", "k2")
	

func _ready() -> void:
	# If running in the editor, skip creating the XR interface
	if OS.has_feature("pc"):
		return
	
	OS.request_permissions()
	var file: FileAccess = FileAccess.open("/test.txt", FileAccess.WRITE)
	file.store_string("test")
	file.close()


	
	# Init the XR interface
	interface = XRServer.find_interface("Native mobile") as MobileVRInterface
	interface.initialize()
	if interface and interface.initialize():
		get_viewport().use_xr = true
	else:
		return
		
	# Load config file if it exists, else create it with default values 
	if config.load(config_path) == OK:
		load_properties()
	else:
		save_properties()
	
		
