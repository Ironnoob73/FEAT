shader_type spatial;

//from: https://godotshaders.com/shader/cloud-bed-w-depth-coloring/
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_back, diffuse_lambert, specular_schlick_ggx;


// Varyings
varying float var_cloud_texture;
varying float var_max_noise_val;

uniform vec2 Speed_1 = vec2(-0.010000, 0.015000);
uniform sampler2D Cloud_Noise_1;
uniform float noise_multiplier : hint_range(0.00999999977648, 10.0) = 0.10000000149012;
uniform vec2 Speed_2 = vec2(-0.010000, 0.015000);
uniform sampler2D Cloud_Noise_2;
uniform vec4 scatter_color : source_color = vec4(0.816633, 0.911976, 0.929008, 1.000000);
uniform vec4 base_color : source_color = vec4(0.925353, 0.925353, 0.925353, 1.000000);
uniform float cloud_transparency_threshold : hint_range(0.0, 1.0) = 0.10000000149012;
uniform float transparency_multiplier = 1.0;
uniform float cloud_thickness : hint_range(0.10000000149012, 100.0) = 5.0;
uniform sampler2D depth_tex_frg_30 : hint_depth_texture;



void vertex() {
// Input:11
	vec3 n_out11p0 = VERTEX;


// Input:13
	vec3 n_out13p0 = NORMAL;


// Vector2Parameter:3
	vec2 n_out3p0 = Speed_1;


// Input:2
	float n_out2p0 = TIME;


// VectorOp:5
	vec3 n_out5p0 = vec3(n_out3p0, 0.0) * vec3(n_out2p0);


// Input:4
	vec2 n_out4p0 = UV;


// VectorOp:6
	vec3 n_out6p0 = n_out5p0 + vec3(n_out4p0, 0.0);


	vec4 n_out7p0;
// Texture2D:7
	n_out7p0 = texture(Cloud_Noise_1, vec2(n_out6p0.xy));


	vec3 n_out37p0;
// Remap:37
	vec3 n_in37p1 = vec3(0.00000, 0.00000, 0.00000);
	vec3 n_in37p2 = vec3(1.00000, 1.00000, 1.00000);
	vec3 n_in37p3 = vec3(0.00000, -1.00000, 0.00000);
	vec3 n_in37p4 = vec3(1.00000, 1.00000, 1.00000);
	{
		vec3 __input_range = n_in37p2 - n_in37p1;
		vec3 __output_range = n_in37p4 - n_in37p3;
		n_out37p0 = n_in37p3 + __output_range * ((vec3(n_out7p0.xyz) - n_in37p1) / __input_range);
	}


// FloatParameter:16
	float n_out16p0 = noise_multiplier;


// VectorOp:14
	vec3 n_out14p0 = n_out37p0 * vec3(n_out16p0);


// Vector2Parameter:18
	vec2 n_out18p0 = Speed_2;


// Input:17
	float n_out17p0 = TIME;


// VectorOp:20
	vec3 n_out20p0 = vec3(n_out18p0, 0.0) * vec3(n_out17p0);


// Input:19
	vec2 n_out19p0 = UV;


// VectorOp:21
	vec3 n_out21p0 = n_out20p0 + vec3(n_out19p0, 0.0);


	vec4 n_out31p0;
// Texture2D:31
	n_out31p0 = texture(Cloud_Noise_2, vec2(n_out21p0.xy));


	vec3 n_out38p0;
// Remap:38
	vec3 n_in38p1 = vec3(0.00000, 0.00000, 0.00000);
	vec3 n_in38p2 = vec3(1.00000, 1.00000, 1.00000);
	vec3 n_in38p3 = vec3(0.00000, -1.00000, 0.00000);
	vec3 n_in38p4 = vec3(1.00000, 1.00000, 1.00000);
	{
		vec3 __input_range = n_in38p2 - n_in38p1;
		vec3 __output_range = n_in38p4 - n_in38p3;
		n_out38p0 = n_in38p3 + __output_range * ((vec3(n_out31p0.xyz) - n_in38p1) / __input_range);
	}


// VectorOp:28
	vec3 n_out28p0 = vec3(n_out16p0) * n_out38p0;


// VectorOp:33
	vec3 n_out33p0 = n_out14p0 + n_out28p0;


// VectorOp:40
	vec3 n_in40p1 = vec3(2.00000, 2.00000, 2.00000);
	vec3 n_out40p0 = n_out33p0 / n_in40p1;


// VectorFunc:39
	vec3 n_out39p0 = abs(n_out40p0);


// VectorOp:34
	vec3 n_out34p0 = n_out13p0 * n_out39p0;


// VectorOp:35
	vec3 n_out35p0 = n_out11p0 + n_out34p0;


// Output:0
	VERTEX = n_out35p0;


// VectorDecompose:41
	float n_out41p0 = n_out39p0.x;
	float n_out41p1 = n_out39p0.y;
	float n_out41p2 = n_out39p0.z;


// VaryingSetter:36
	var_cloud_texture = n_out41p1;


// VaryingSetter:42
	var_max_noise_val = n_out16p0;


}

void fragment() {
// ColorParameter:7
	vec4 n_out7p0 = scatter_color;


// ColorParameter:8
	vec4 n_out8p0 = base_color;


// VaryingGetter:22
	float n_out22p0 = var_cloud_texture;


// VaryingGetter:29
	float n_out29p0 = var_max_noise_val;


	float n_out28p0;
// Remap:28
	float n_in28p1 = 0.00000;
	float n_in28p3 = 0.00000;
	float n_in28p4 = 1.00000;
	{
		float __input_range = n_out29p0 - n_in28p1;
		float __output_range = n_in28p4 - n_in28p3;
		n_out28p0 = n_in28p3 + __output_range * ((n_out22p0 - n_in28p1) / __input_range);
	}


// Mix:23
	vec3 n_out23p0 = mix(vec3(n_out7p0.xyz), vec3(n_out8p0.xyz), vec3(n_out28p0));


// FloatParameter:27
	float n_out27p0 = cloud_transparency_threshold;


// FloatOp:26
	float n_out26p0 = n_out28p0 + n_out27p0;


// FloatParameter:25
	float n_out25p0 = transparency_multiplier;


// FloatOp:24
	float n_out24p0 = n_out26p0 * n_out25p0;


// FloatParameter:31
	float n_out31p0 = cloud_thickness;


	float n_out30p0;
// ProximityFade:30
	{
		float __depth_tex = texture(depth_tex_frg_30, SCREEN_UV).r;
		vec4 __depth_world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, __depth_tex, 1.0);
		__depth_world_pos.xyz /= __depth_world_pos.w;
		n_out30p0 = clamp(1.0 - smoothstep(__depth_world_pos.z + n_out31p0, __depth_world_pos.z, VERTEX.z), 0.0, 1.0);
	}


// FloatOp:32
	float n_out32p0 = n_out24p0 * n_out30p0;


// Output:0
	ALBEDO = n_out23p0;
	ALPHA = n_out32p0;


}