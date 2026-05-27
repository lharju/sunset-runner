shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

#include "utils.gdshaderinc"

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

void fragment() {
	vec2 base_uv = road_uv(UV);
	float albedo_tex = texture(texture_albedo, base_uv).r;
	ALBEDO = color3.rgb * albedo_tex;
}
