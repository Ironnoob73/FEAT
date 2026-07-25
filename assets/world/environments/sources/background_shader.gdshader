//from: https://godotshaders.com/shader/n64-style-skybox/
shader_type spatial;
render_mode depth_draw_opaque, unshaded;

uniform sampler2D sky_texture : source_color;

varying vec4 BG_COORDS;

void vertex() {
	//Camera YX rotation per Basis.get_euler source code
	float y = atan(VIEW_MATRIX[0][3], VIEW_MATRIX[0][3]);
	float x = asin(VIEW_MATRIX[0][3]);
	
	//Map rotation to screen space
	BG_COORDS.xy = vec2(y * -0.5, x) / PI;
	BG_COORDS.y += 0.5;
	
	BG_COORDS.w = 1.0;
	BG_COORDS.z = 1.0;
	
	//Keep background centered vertically when FOV changes
	BG_COORDS.y = 0.0;
}

void fragment() {
	vec2 uv = SCREEN_UV * BG_COORDS.zw + BG_COORDS.xy;
	ALBEDO = texture(sky_texture, uv).rgb;
	ALPHA = texture(sky_texture, uv).a;
}