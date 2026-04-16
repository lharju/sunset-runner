shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

global uniform vec4 color1 : source_color;
global uniform vec4 color2 : source_color;
global uniform vec4 color3 : source_color;

void fragment() {
	vec2 base_uv = UV * uv1_scale.xy + uv1_offset.xy + vec2(0.0, -TIME);

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = color3.rgb * albedo_tex.rgb;

}
