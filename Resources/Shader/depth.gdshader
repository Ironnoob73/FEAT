shader_type spatial;
render_mode unshaded;
uniform sampler2D depth_texture : source_color, hint_depth_texture;


void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	ALBEDO = vec3(0,0,0) + view.w;
}