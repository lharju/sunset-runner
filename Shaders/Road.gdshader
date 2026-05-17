shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;


uniform sampler2D texture_albedo : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D curve : repeat_disable, filter_linear_mipmap_anisotropic;

global uniform vec4 color1 : source_color;
global uniform vec4 color2 : source_color;
global uniform vec4 color3 : source_color;
global uniform int road_movement;
global uniform sampler2D road_curve_texture : repeat_disable;

uniform float roadmark_density = 64.;
uniform float roadmark_freq = 3.0;


void vertex() {
	
	VERTEX.x += texture(road_curve_texture, vec2(UV.y, 0.0)).r * 32.;
}

void fragment() {
	//ALBEDO = vec3(1.0) * sign(cos(UV.x * 2. - TIME * 2.0)) * clamp(sign(sin(UV.y * PI) - 0.7), 0.0, 1.0);

	
	// Roadmarks
	float x = sign(cos(UV.y * roadmark_density - TIME * roadmark_freq* float(road_movement)));
	float y = clamp(sign(sin(UV.x * PI) -0.999),0.0, 1.0);
	float roadmark = clamp(x * y -0.5, 0.0, 1.0);
	
	// 
	vec3 gradient = mix(color1 * 3.0, color2, clamp(pow(UV.y + 0.55, 4.)  , 0.0, 1.0)).rgb;
	
	ALBEDO = gradient;
	ALBEDO = mix(gradient, color3.rgb, roadmark);
	
}
