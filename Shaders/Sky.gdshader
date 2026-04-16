shader_type sky;

uniform sampler2D horizon_color_tex : source_color;


uniform float horizon_curve = 10.0;

uniform float flare_size = 0.6;
uniform float flare_int = 10.0;

uniform bool lines = false;

global uniform vec4 color1 : source_color;
global uniform vec4 color2 : source_color;
global uniform vec4 color3 : source_color;

uniform sampler3D noise;


void sky() {
	// Calculate Sun properties
	float sun_angle = acos(dot(EYEDIR, LIGHT0_DIRECTION));
	float sun_str = max(sign(sun_angle - LIGHT0_SIZE), 0.0);
	vec3 sun_color = color1.rgb * LIGHT0_ENERGY;
	
	// Calculate flare strength
	float flare = clamp(1.0 - abs(sun_angle - LIGHT0_SIZE) / (LIGHT0_SIZE * flare_size), 0.0 , 1.0);
	
	// Calculate background color
	vec3 horizon_color = mix(color2.rgb, color3.rgb, clamp(EYEDIR.y * horizon_curve, 0.0, 1.0)) * pow(1.0 - clamp(EYEDIR.y, 0.0, 1.0), horizon_curve);
	

	// Lines Config
	float line_density = 32.;
	float line_freq = 0.1;
	
	float lines_str = 10. * clamp((LIGHT0_DIRECTION.y - EYEDIR.y + 0.3), 0.0, 100.0) ;
	float phase = (pow(lines_str, 0.7) - TIME * line_freq) * line_density;
	
	float temp = clamp(sin(phase) * 10. , 0.0, 1.0);
	
	if (lines)
		sun_color = mix(sun_color, horizon_color, temp * pow(lines_str, 0.3));
	
	float a = texture(noise, vec3(EYEDIR.yz, TIME* 0.1)).r;
	
	//COLOR = vec3(1.0) * lines_str;
	//COLOR = vec3(1.0) * (1.0 - clamp(acos(dot(EYEDIR.xyz, LIGHT0_DIRECTION.xyz)) / LIGHT0_SIZE, 0.0, 1.0));
	//COLOR = vec3(1.0) * (acos(dot(normalize(LIGHT0_DIRECTION.zy), normalize(EYEDIR.zy)))) ;
	COLOR = vec3(1.0) * lines_str;
	//COLOR = texture(noise, EYEDIR + vec3(0.0, 0.3, 0.0) * TIME).rgb;
	COLOR = (mix(sun_color, horizon_color * pow(a, 0.1), sun_str) + pow(flare, flare_int) * color1.rgb)* (1.0 - 0.08 * (sin(EYEDIR.y * 300.0 + TIME * 16.) * 0.5 + 0.5));

}
