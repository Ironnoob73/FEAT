shader_type spatial;

uniform sampler2D albedo : source_color, filter_nearest;
uniform vec3 color : source_color;

void vertex()
{
	UV = UV * vec2(3.0,2.0);
}
void fragment()
{
	vec4 color_base = COLOR;
	vec4 texture_color = texture(albedo, UV);

	ALPHA = (color_base * texture_color).a;
	
	ALBEDO.rgb = color ;
	ALBEDO.rgb = 0.5 + texture_color.rgb * sin(TIME*4.0);
	
	EMISSION.rgb = color * (sin(TIME*4.0)+1.0);
}