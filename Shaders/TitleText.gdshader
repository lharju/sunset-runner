shader_type spatial;
render_mode unshaded;

uniform sampler2D vtexture : source_color, filter_nearest_mipmap;


global uniform vec4 color1 : source_color;
global uniform vec4 color2 : source_color;
global uniform vec4 color3 : source_color;
global uniform int road_movement;

varying vec3 global_pos;
void vertex() {
	VERTEX.y += sin(VERTEX.x + TIME) * 0.07;
	global_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}


void fragment() {
	vec2 uv = (UV * 2.0 - 1.0) * VIEW.xz ;
	vec4 tex = texture(vtexture, uv * 0.5 + 0.5);
	ALPHA = tex.a;
	ALBEDO = vec3(0.0) * tex.rgb;
	ALBEDO = texture(vtexture, UV).rgb;
	ALBEDO = mix(color2, color3, global_pos.y* 0.9 - 2.0).rgb;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
