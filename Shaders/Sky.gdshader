shader_type sky;

uniform vec3 horizon_color : source_color;
uniform float horizon_curve = 18.0;

uniform float flare_size = 0.6;
uniform float flare_int = 10.0;

void sky() {

	float sun_angle = acos(dot(EYEDIR, LIGHT0_DIRECTION));
	float flare = clamp(1.0 - abs(sun_angle - LIGHT0_SIZE) / (LIGHT0_SIZE * flare_size), 0.0 , 1.0);

	
	if (sun_angle <= LIGHT0_SIZE) {
		COLOR = LIGHT0_COLOR * LIGHT0_ENERGY;
	}
	else {
		COLOR = horizon_color * pow(1.0 - clamp(EYEDIR.y, 0.0, 1.0), horizon_curve);
	}

	COLOR += pow(flare, flare_int) * LIGHT0_COLOR;
}
