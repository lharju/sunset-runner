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

void vertex() {
	vec2 vw = vec2(UV.y, 0.0) * 0.5 + 0.25;
	VERTEX.x += (texture(road_curve_texture, vw).r * 2.0 - 1.0) * road_deviation;
}

void fragment() {
	vec2 base_uv = road_uv(UV);
	float roadmark = step(abs(base_uv.x), 0.5) * step(fract(base_uv.y), 0.2);
	vec3 gradient = mix(color1 * 3.0, color2, clamp(pow(UV.y + 0.55, 4.) , 0.0, 1.0)).rgb;
	
	ALBEDO = mix(gradient, color3.rgb, roadmark);
}
