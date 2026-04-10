shader_type sky;

uniform vec3 horizon_top : source_color;
uniform vec3 horizon_bot : source_color;
uniform vec3 flare_clr : source_color;
uniform float horizon_curve = 10.0;

uniform float flare_size = 0.6;
uniform float flare_int = 10.0;

uniform bool lines = false;



void sky() {
	// Calculate Sun properties
	float sun_angle = acos(dot(EYEDIR, LIGHT0_DIRECTION));
	vec3 sun_color = LIGHT0_COLOR * LIGHT0_ENERGY;
	float sun_str = max(sign(sun_angle - LIGHT0_SIZE), 0.0);
	
	// Calculate flare strength
	float flare = clamp(1.0 - abs(sun_angle - LIGHT0_SIZE) / (LIGHT0_SIZE * flare_size), 0.0 , 1.0);
	
	// Calculate background color
	vec3 horizon_color = mix(horizon_bot, horizon_top, EYEDIR.y * horizon_curve) * pow(1.0 - clamp(EYEDIR.y, 0.0, 1.0), horizon_curve);

	float line_density = 20.;
	float line_freq = 0.1;
	float lines_str = 5. * clamp((LIGHT0_DIRECTION.y - EYEDIR.y + 0.1), 0.0, 100.0) ;
	float phase = (pow(lines_str, 0.3) - TIME * line_freq) * line_density;
	
	float temp = clamp(sin(phase) * 10. , 0.0, 1.0);
	
	if (lines)
		sun_color = mix(sun_color, horizon_color, temp * pow(lines_str, 0.3));
	
		
	COLOR = vec3(1.0) * lines_str;
	COLOR = vec3(1.0) * temp;
	COLOR = mix(sun_color, horizon_color, sun_str) + pow(flare, flare_int) * flare_clr;	
}
