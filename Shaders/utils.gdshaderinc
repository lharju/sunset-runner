global uniform vec4 color1 : source_color;
global uniform vec4 color2 : source_color;
global uniform vec4 color3 : source_color;
global uniform sampler2D road_curve_texture : repeat_disable;
global uniform float road_deviation;
global uniform int road_movement;
global uniform float road_scale;
global uniform float road_speed;
global uniform float time;

vec3 rrf(vec3 v, vec3 k, float theta) {
	// Rodriques rotation formula
	// https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
	vec3 v_rot = v * cos(theta) + cross(k, v) * sin(theta) + k * dot(k, v) * (1.0 - cos(theta));
	return v_rot;
}

vec3 calculate_normal(vec3 eyedir, vec3 light_dir, float light_size){
	// Calculate normal for light, assuming light is perfect sphere
	vec3 axis = normalize(cross(eyedir, light_dir));
	float rot = acos(dot(eyedir, light_dir)) / (light_size / 2.0);
	vec3 normal = rrf(light_dir, axis, asin(rot));
	return normalize(normal);
}

vec2 road_uv(vec2 uv) {
	return (uv - 0.5) * road_scale - road_speed * vec2(0.0, time) * float(road_movement);;
}