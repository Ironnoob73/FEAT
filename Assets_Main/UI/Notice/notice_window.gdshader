shader_type canvas_item;
uniform vec4 color : source_color = vec4(0.5,0.5,0.5,1);
uniform float alpha = 1.0;

void fragment() {
	vec2 size = SCREEN_PIXEL_SIZE;
	COLOR = color;
	if ( mod(( FRAGCOORD.x + FRAGCOORD.y - TIME * 100.0) / ( 0.25/ size).y, 1) < 0.5) {
		COLOR *= vec4(0.75, 0.75, 0.75, 1.0);
	}
	COLOR.a = UV.y * 0.5 * alpha;
}