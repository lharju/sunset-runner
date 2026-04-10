shader_type spatial;
uniform sampler2D vtexture : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = (UV * 2.0 - 1.0) * VIEW.xz ;
	vec4 tex = texture(vtexture, uv * 0.5 + 0.5);
	ALPHA = tex.a;
	ALBEDO = vec3(0.0) * tex.rgb;
	ALBEDO = texture(vtexture, UV).rgb;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
