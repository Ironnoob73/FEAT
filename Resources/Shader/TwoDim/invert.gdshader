shader_type canvas_item;
//To reuse the deleted menthod
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture , filter_linear_mipmap ;

void fragment() {
	vec4 screen_color = texture(SCREEN_TEXTURE,SCREEN_UV);
	COLOR.rgb = vec3(1.0) - screen_color.rgb;
}
