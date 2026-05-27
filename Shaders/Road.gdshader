shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

#include "utils.gdshaderinc"

void vertex() {
	VERTEX.x += texture(road_curve_texture, vec2(UV.y, 0.0)).r * road_deviation;
}

void fragment() {
	vec2 base_uv = road_uv(UV);
	float roadmark = step(abs(base_uv.x), 0.5) * step(fract(base_uv.y), 0.2);
	vec3 gradient = mix(color1 * 3.0, color2, clamp(pow(UV.y + 0.55, 4.) , 0.0, 1.0)).rgb;
	
	ALBEDO = mix(gradient, color3.rgb, roadmark);
}
