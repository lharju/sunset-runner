shader_type spatial;
render_mode shadows_disabled, unshaded;

uniform sampler2D grid_tex : source_color;

uniform vec3 color : source_color = vec3(1.0);
uniform float grid_int = 32.0;
uniform float blur_int = 64.0;
uniform float freq = 1.0;
uniform float scale = 512.;

void fragment() {
	vec2 uv = (UV - vec2(0.5)) * scale + vec2(0.0, - TIME * freq);
	float blur = length(VERTEX) / blur_int;
	
	ALBEDO = color * pow(texture(grid_tex, uv).r, grid_int);//pow(max(sin(uv.x), sin(uv.y)), grid_int ); 1. * (1.0 - blur);
}
