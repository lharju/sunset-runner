@tool
extends SubViewport


@export_tool_button("Screenshot") var scrsht: Callable = screenshot


func screenshot() -> void:
	print("screenshot taken")
	var texture: Image = self.get_texture().get_image()
	texture.save_png("res://image.png")
