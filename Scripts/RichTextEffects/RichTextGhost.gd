@tool
extends RichTextEffect
class_name RichTextGhost

# Syntax: [ghost freq=5.0 span=10.0][/ghost]

# Define the tag name.
var bbcode: String = "ghost"
var color_a: Color = Color(1.0, 0.894, 0.0, 1.0)
var color_b: Color = Color(1.0, 0.0, 0.933, 1.0)

func _process_custom_fx(char_fx: CharFXTransform):
	# Get parameters, or use the provided default value if missing.
	var speed = char_fx.env.get("freq", 5.0)
	var span = char_fx.env.get("span", 10.0)

	var alpha = sin(char_fx.elapsed_time * speed + (char_fx.range.y / span)) * 0.5 + 0.5
	
	char_fx.color = color_a.lerp(color_b, alpha)
	 
	return true
