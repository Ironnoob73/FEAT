shader_type spatial;
render_mode unshaded;
uniform sampler2D depth_texture : source_color, hint_normal_roughness_texture;


void fragment() {
	ALBEDO = vec3(0,0,0) + texture(depth_texture, SCREEN_UV).w;
}