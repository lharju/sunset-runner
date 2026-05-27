shader_type sky;
render_mode use_debanding;

#include "utils.gdshaderinc"

group_uniforms sun;
	uniform vec2 sun_pos = vec2(0.0);
	uniform float sun_size = 20.0;
	uniform float sun_energy = 3.0;
	uniform float flare_size = 0.6;
	uniform float flare_int = 10.0;

group_uniforms background;
	uniform float horizon_curve = 4.0;
	uniform float line_str = 0.15;
	uniform sampler3D noise : filter_nearest;

group_uniforms grid;
	uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
	uniform float grid_scale = 1.35;
	uniform float grid_height = -0.01;







const float wall_d = 1.0;

void sky() {
	// TODO
	// remove magic numbers
	

		
	vec2 wall_xy = EYEDIR.xy / EYEDIR.z * sign(EYEDIR.z);
	vec2 wall_zy = EYEDIR.zy / EYEDIR.x * sign(EYEDIR.x);
	vec2 wall_xz = EYEDIR.xz / EYEDIR.y * sign(EYEDIR.y);
	vec2 wall_uv = wall_xy * step(abs(wall_xy.x), 1.0) + wall_zy * step(abs(wall_zy.x), 1.0);
	
	// Calculate Sun properties
	float sun_dist = distance(sun_pos, wall_xy);
	float sun_str = step(sun_dist, sun_size) * step(0.0,-EYEDIR.z);
	vec3 sun_color = color1.rgb * sun_energy;
	float flare = clamp(1.0 - abs(sun_dist - sun_size), 0.0, 1.0) * step(0.0,-EYEDIR.z);
	flare = pow(flare, flare_int);
	
	// Calculate background color
	float ratio = clamp(EYEDIR.y * horizon_curve, 0.0, 1.0); // for mixing horizon colors
	float top_fade = pow(1.0 - clamp(EYEDIR.y, 0.0, 1.0), horizon_curve); // for fagding top to black
	float noise_str = texture(noise, vec3(EYEDIR.yz, TIME / 8.0)).r; // randomness in bg
	vec3 background_color = mix(color2.rgb, color3.rgb, ratio) * top_fade * pow(noise_str, 0.4);
		
	// Render background and sun

	
	// ==== CALCULATE NORMAL FOR SUN ==== //
	vec2 sun_offset = (wall_xy - sun_pos)/ sun_size;
	vec3 normal = rrf(vec3(0.0, 0.0, 1.0), vec3(1.0, 0.0, 0.0), asin(sun_offset.x));
	normal = rrf(normal, vec3(0.0, 1.0, 0.0), asin(sun_offset.y));
	
	vec2 magic = normal.xy * sun_str;
	
	float lines = 1.0 - (sin(wall_uv.y* 300. + TIME * TAU *2.0- magic.x * 32.) * 0.5 + 0.5) * line_str;

	vec3 color = (mix(background_color, sun_color,  sun_str) + flare * color1.rgb);

	COLOR = color * lines;

}
