// NOTE: Shader automatically converted from Godot Engine 4.1.4.rc's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform sampler2D texture_albedo : source_color,filter_nearest_mipmap,repeat_enable;
uniform sampler2D texture_mrh : repeat_enable,filter_nearest_mipmap;
uniform sampler2D texture_emission : source_color, hint_default_black,filter_nearest_mipmap,repeat_enable;
uniform sampler2D texture_normal : hint_roughness_normal,filter_nearest_mipmap,repeat_enable;

void fragment() {
	vec2 base_uv = UV;
	{
		vec3 view_dir = normalize(normalize(-VERTEX + EYE_OFFSET) * mat3(TANGENT , -BINORMAL , NORMAL));
		float depth = 0.5 * texture(texture_mrh, base_uv).b;
		vec2 ofs = base_uv - view_dir.xy * depth * 0.05;
		base_uv=ofs;
	}
	ALBEDO = texture(texture_albedo,base_uv).rgb;
	METALLIC = dot(texture(texture_mrh,base_uv),vec4(0.0));
	ROUGHNESS = dot(texture(texture_mrh,base_uv),vec4(0.0,1.0,0.0,0.0));
	NORMAL_MAP = texture(texture_normal,base_uv).rgb;
	NORMAL_MAP_DEPTH = 0.5;
	EMISSION = texture(texture_emission,base_uv).rgb;
}
