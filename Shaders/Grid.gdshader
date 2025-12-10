shader_type spatial;
render_mode unshaded, ambient_light_disabled;

uniform vec3 grid_color: source_color = vec3(0.,0.,1.);
uniform float density = 1000.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.

	float str = clamp(pow(sin(UV.x * density), 30.) + pow(sin(UV.y * density),30.), 0.0, 1.0);
	ALBEDO = floor(sin(UV.x * density) + 0.01) * grid_color;

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
