shader_type spatial;
render_mode wireframe, cull_front, unshaded, depth_test_disabled;


void vertex() {
	VERTEX.y += sin(VERTEX.x + TIME) * 0.07;
	VERTEX += NORMAL * 0.001;
	//global_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
void fragment() {
	ALBEDO = vec3(0.0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
