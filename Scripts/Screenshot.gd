@tool
extends SubViewport


@export_tool_button("Screenshot") var scrsht: Callable = screenshot


func _ready() -> void:
	if not Engine.is_editor_hint():
		self.queue_free()

func screenshot() -> void:
	var texture: Image = self.get_texture().get_image()
	texture.save_png("res://image.png")
	print("screenshot taken")
