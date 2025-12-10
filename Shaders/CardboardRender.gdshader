shader_type canvas_item;

uniform sampler2D viewport_texture: source_color;
uniform float scale = 1.4;
uniform float k = 0.4;

uniform float h_offset = 0.0;
uniform float v_offset = 0.0;

vec2 scale_uv(vec2 uv, float c) {
	return (uv * 2.0 - 1.0) * c * 0.5 + 0.5;
}

void fragment() {
	// Scale to [-1 1] and apply offset
	vec2 XY_d = UV * 2.0 - 1.0 + vec2(h_offset, v_offset);
	vec2 dir = normalize(XY_d) / (1.0 + k);

	float r_d = length(XY_d);
	float r_u = r_d * (1.0 + k * r_d * r_d);

	vec2 XY = dir * r_u;
	// Scale back to [0 1]
	XY = XY * 0.5 + 0.5;
	vec2 uv = clamp(XY, vec2(0.0), vec2(1.0));
	uv = scale_uv(uv, scale);

	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0){
		COLOR = vec4(0.0, 0.0, 0.0 ,1.0);
	}
	else {
		COLOR = texture(viewport_texture, uv).rgba;
	}

}
