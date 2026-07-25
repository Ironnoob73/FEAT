shader_type spatial;
render_mode unshaded , blend_mix;

uniform vec4 color : source_color = vec4( 0.0, 0.0, 0.0, 0.0 );
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void vertex() {}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec3 original = texture(SCREEN_TEXTURE, uv).rgb;
	float gray = original.r * 0.299 + original.g * 0.587 + original.b * 0.114;
	ALBEDO = gray * color.rgb;
	ALPHA = color.a;
}
