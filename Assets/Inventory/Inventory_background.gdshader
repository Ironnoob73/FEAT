shader_type canvas_item;
uniform float translucent;

void fragment() {
	vec2 uv = UV;
	vec2 size = SCREEN_PIXEL_SIZE;
	uv = (vec2(2.0 * FRAGCOORD.x,2.5 * FRAGCOORD.y) - (1.0 / size).xy)/(1.0 / size).y;//https://godotshaders.com/shader/perspective-grid/
	uv.x = uv.x/(uv.y/5.0);
	uv.y = 7.0 * log2(uv.y);
	vec4 pixelColor = texture( TEXTURE, uv * 1.0 - vec2( 0.1, 0.0 ) * TIME);
	if (pixelColor.g>0.5)
		pixelColor.g += (uv.y/50.0);
	if (pixelColor.g<0.5)
		pixelColor.g = 0.5;
	pixelColor.a = translucent;
	COLOR = pixelColor;
}
