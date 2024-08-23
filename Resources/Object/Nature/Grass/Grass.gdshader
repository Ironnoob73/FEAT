// From : https://godotshaders.com/shader/stylized-cartoon-grass/
shader_type spatial;

//render_mode unshaded; //Use 'cull_back' if billboard Y

uniform sampler2D texture_albedo : source_color,filter_nearest;
// Internally capped at 16
const int TOTAL_GRASS_VARIANTS = 4;

uniform bool billboard_y = true;


void vertex(){
	// Wind sway
	float root = (1.0 - UV.y);
	vec3 sway;
	sway.x = sin(NODE_POSITION_WORLD.x + TIME * 1.25 + UV.y) * root * 0.10;
	sway.y = sin(NODE_POSITION_WORLD.x + TIME * 0.6 + UV.y) * root * 0.08;
	sway.z = cos(NODE_POSITION_WORLD.z + TIME * 0.45 + UV.y) * root * 0.15;

	if(billboard_y){
		VERTEX += sway;
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
	}
	else{
		VERTEX += (vec4(sway, 1.0) * MODEL_MATRIX).xyz;
	}
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a;
}