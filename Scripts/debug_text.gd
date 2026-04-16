extends Label3D

func _ready() -> void:
	var dir := DirAccess.open("user://")
	if dir == null: 
		printerr("Could not open folder")
		return
	var temp = ""
	for file: String in dir.get_files():
		temp += file + "\n"
	text = temp
	
