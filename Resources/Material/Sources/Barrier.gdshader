shader_type spatial;
render_mode unshaded;
uniform vec4 albedo : source_color = vec4(1.0,1.0,1.0,1.0);
uniform sampler2D texture_albedo : source_color,filter_nearest_mipmap,repeat_enable;
uniform float distance_fade_min = 5.0;
uniform float distance_fade_max = 2.5;

varying vec3 uv1_triplanar_pos;
varying vec3 uv1_power_normal;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

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
	uv1_power_normal=abs(NORMAL);
	vec3 uv1_offset_time = vec3(uv1_offset.x + TIME,uv1_offset.y + TIME,uv1_offset.z - TIME);
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset_time;
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
}
vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	vec4 albedo_tex = triplanar_texture(texture_albedo,uv1_power_normal,uv1_triplanar_pos);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	
	ALPHA *= albedo.a * albedo_tex.r;
	ALPHA *= clamp(smoothstep(distance_fade_min, distance_fade_max, length(VERTEX)), 0.0,5.0);
}
