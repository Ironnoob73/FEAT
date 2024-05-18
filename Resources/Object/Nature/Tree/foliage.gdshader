// From : https://github.com/FaRu85/Godot-Foliage/blob/main/Shader/foliage.gdshader
shader_type spatial;

render_mode blend_mix, depth_draw_opaque, specular_schlick_ggx, depth_prepass_alpha ;
uniform sampler2D texture_albedo : source_color,filter_nearest;

uniform float WindScale : hint_range(1.0, 20.0) = 20.0;
uniform float WindSpeed : hint_range(0.0, 20.0) = 20.0;
uniform float WindStrength : hint_range(1.0, 20.0) = 10.0;
uniform float WindDensity : hint_range(1.0, 20.0) = 20.0;
uniform float ClampTop : hint_range(0.0, 1.0) = 1.0;
uniform float ClampBtm : hint_range(-1.0, 0.0) = -1.0;
uniform float MeshScale : hint_range(-5.0, 5.0) = 1.0;
uniform bool DeactivateGlobalVariation = false;

uniform float DistanceScale : hint_range(0.0, 5.0) = 0.0;
uniform float DistanceStart = 0;
uniform float DistanceScaleRange = 70;

vec2 rotateUV(vec2 uv, float rotation, vec2 mid)
{
	float cosAngle = cos(rotation);
	float sinAngle = sin(rotation);
	return vec2(
		cosAngle * (uv.x - mid.x) + sinAngle * (uv.y - mid.y) + mid.x,
		cosAngle * (uv.y - mid.y) - sinAngle * (uv.x - mid.x) + mid.y
	);
}

varying vec3 obj_vertex;
void vertex()
{
	float distanceScale = 1.0;
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;	//Generates world coordinates for vertecies
	vec3 distance_vector = world_pos - (INV_VIEW_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	float square_distance = distance_vector.x * distance_vector.x + distance_vector.y * distance_vector.y + distance_vector.z * distance_vector.z;
	float square_end = (DistanceScaleRange + DistanceStart) * (DistanceScaleRange + DistanceStart);
	float square_start = DistanceStart * DistanceStart;
	float square_range = square_end - square_start;
	
	float distance_influence = clamp((square_distance - square_start) / square_range, 0.0, 1.0);
	//Camera-Orientation based on https://www.youtube.com/watch?v=iASMFba7GeI
	vec3 orient_2d = vec3(1.0, 1.0, 0.0) - vec3(UV.x, UV.y, 0.0);
	orient_2d *= 2.0;
	orient_2d -= vec3(1.0, 1.0, 0.0);
	orient_2d *= -1.0;
	orient_2d *= MeshScale;
	orient_2d *= (1.0 + distance_influence * DistanceScale);
	
	vec3 oriented_offset = reflect((INV_VIEW_MATRIX * vec4(orient_2d, 0.0)).xyz,INV_VIEW_MATRIX[0].xyz);
	vec3 obj_oriented_offset = (vec4(oriented_offset, 0.0) * MODEL_MATRIX).xyz;
	
	//Wind-Effect
	//adapted from: https://github.com/ruffiely/windshader_godot
	float contribution = 1.0 * (1.0 - float(DeactivateGlobalVariation));
	vec3 world_pos_eff = world_pos * contribution;	//Generates world coordinates for vertecies
	// Removed using world_position due to dragging bug
	float positional_influence = -VERTEX.x + VERTEX.z -world_pos_eff.x + world_pos_eff.z;
	float offset = fract(positional_influence * (1.0 / WindScale) + (TIME * WindScale/1000.0));	//Generates linear curve that slides along vertecies in world space
	offset = min(1.0 - offset, offset);														//Makes generated curve a smooth gradient
	offset = (1.0 - offset) * offset * 2.0;													//Smoothes gradient further
	
	float t = TIME + sin(TIME + offset + cos(TIME + offset * WindStrength * 2.0) * WindStrength); //Generates noise in world space value
	
	//float mask = fract(v.y * wind_density) * v.y; //Generates vertical mask, so leaves on top move further than leaves on bottom
	//mask = clamp(mask, 0.0, 1.0);                 //Clamps mask
	
	float mask = clamp(VERTEX.y* WindDensity, 0.0, 1.0) * (ClampTop - ClampBtm) + ClampBtm;
	
	
	float si = sin(t) / 20.0 * WindStrength * offset;	//Generates clamped noise, adds strength, applies gradient mask
	float csi = cos(t)/ 20.0 * WindStrength * offset;	//Generates clamped noise with offset, adds strength, applies gradient mask
		
	vec3 wind_offset = vec3(VERTEX.x * si * mask, VERTEX.y * si * mask, VERTEX.z * csi * mask);
	
	VERTEX += obj_oriented_offset + wind_offset;
	
	obj_vertex = VERTEX;
}

void fragment()
{
	float rate_col1 = clamp(COLOR.r,0.0, 1.0);
	float rate_col2 = 1.0 - rate_col1;
	
	float fresnel = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
	float fresnel_rate = clamp(rate_col1,0.1,1);
	
	vec2 uv = UV;
	uv = clamp(uv, 0.0, 1.0);
	float x = COLOR.b;
	
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a;
}