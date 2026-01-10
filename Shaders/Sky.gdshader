shader_type sky;

uniform vec3 horizon_tint : source_color;
uniform float horizon_curve = 18.0;

uniform float flare_size = 0.6;
uniform float flare_int = 10.0;

uniform sampler2D horizon_noise;

void sky() {

	float sun_angle = acos(dot(EYEDIR, LIGHT0_DIRECTION));
	float flare = clamp(1.0 - abs(sun_angle - LIGHT0_SIZE) / (LIGHT0_SIZE * flare_size), 0.0 , 1.0);


	COLOR = vec3(1.0) * floor(abs(sin(pow(EYEDIR.y, 4.0) * 100. + TIME))* 1.5);
	float c = clamp(LIGHT0_DIRECTION.y - EYEDIR.y, 0.0, 1.0);
	//c = floor(abs(sin(c + 0.2));
	vec3 sun_color = LIGHT0_COLOR * LIGHT0_ENERGY;
	float a = texture(horizon_noise, vec2(EYEDIR.z, TIME * 0.01)).x * 0.05 - 0.02;
	vec3 horizon_color = horizon_tint * pow(1.0 - clamp(EYEDIR.y + a, 0.0, 1.0), horizon_curve);


	COLOR = vec3(1.0) * c; //abs(sin(pow(c, 1.0) * 40.0 + TIME));
	COLOR = mix(sun_color, horizon_color, max(sign(sun_angle - LIGHT0_SIZE), 0.0));
	COLOR += pow(flare, flare_int) * LIGHT0_COLOR;

}

