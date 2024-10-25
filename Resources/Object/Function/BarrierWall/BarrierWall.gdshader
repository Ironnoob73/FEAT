shader_type spatial;
render_mode unshaded,cull_disabled;
uniform vec4 albedo : source_color = vec4(1.0,1.0,1.0,1.0);
uniform sampler2D texture_albedo : source_color,filter_nearest_mipmap,repeat_enable;

uniform vec2 uv1_scale = vec2(10.0,10.0);
uniform vec2 uv1_offset;
uniform float speed = 1.0;
uniform float alpha = 1.0;

void vertex() {
	vec3 normal = NORMAL;
	TANGENT = vec3(0.0,0.0,-1.0) * abs(normal.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(normal.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(normal.z);
	TANGENT = normalize(TANGENT);
	BINORMAL = vec3(0.0,1.0,0.0) * abs(normal.x);
	BINORMAL+= vec3(0.0,0.0,-1.0) * abs(normal.y);
	BINORMAL+= vec3(0.0,1.0,0.0) * abs(normal.z);
	BINORMAL = normalize(BINORMAL);
}

void fragment() {
	ALBEDO = albedo.rgb * texture(texture_albedo,vec2(UV.y*uv1_scale.y+uv1_offset.y,UV.x*uv1_scale.x+uv1_offset.x)+TIME*speed).rgb;

	ALPHA *= albedo.a * texture(texture_albedo,vec2(UV.y*uv1_scale.y+uv1_offset.y,UV.x*uv1_scale.x+uv1_offset.x)+TIME*speed).r;
	ALPHA *= clamp(pow(((0.8-UV.x) + UV.y)/1.5,2.5),0.0,1.0);
	ALPHA *= alpha;

}
