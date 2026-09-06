shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

global uniform vec4 color1 : source_color;
global uniform vec4 color2 : source_color;
global uniform vec4 color3 : source_color;
global uniform sampler2D road_curve_texture : repeat_disable;
global uniform float road_deviation;
global uniform int road_movement;
global uniform float road_scale;
global uniform float road_speed;
global uniform float time;
global uniform int low_vection;

vec2 road_uv(vec2 uv) {
	return (uv - 0.5) * road_scale - road_speed * vec2(0.0, time) * float(road_movement) * road_scale;
}

vec2 grid_uv(vec2 uv) {
	return (uv - 0.5) * road_scale - road_speed * vec2(0.0, time) * float(road_movement) * float(low_vection)* road_scale;
}

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

void fragment() {
	vec2 base_uv = grid_uv(UV);
	float albedo_tex = texture(texture_albedo, base_uv).r;
	ALBEDO = color3.rgb * albedo_tex;
}
