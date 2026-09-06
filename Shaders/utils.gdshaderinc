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
