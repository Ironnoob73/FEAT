// From: https://godotshaders.com/shader/fake-3d-interior-projection-shader-fixed-adjustable/?post_id=14595&new_post=true

// MIT License
// 
// Copyright (c) 2026 [PROJEKTSANSSTUDIOS]
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Configurable Fake 3D Interior Shader
// Description: Creates a 3D interior illusion with customizable face parameters

shader_type spatial;
render_mode unshaded;

uniform sampler2D room_atlas : filter_nearest_mipmap;
uniform float brightness : hint_range(0.0, 4.0) = 1.0; // Brightness control clamped 0-4

/* 0:+X  1:-X  2:+Y  3:-Y  4:+Z  5:-Z */
uniform vec2 face_offset[6];
uniform vec2 face_size[6];

uniform float left_depth = 0.5;
uniform float right_depth = 0.5;
uniform float top_depth = 0.5;
uniform float bottom_depth = 0.5;
uniform float front_depth = 1.0;
uniform float layer0_depth = 0.75;
uniform float layer1_depth = 0.5;
uniform float layer2_depth = 0.25;

varying vec3 v_pos;
varying vec3 v_cam;

vec2 face_uv(vec3 p, vec3 f) {
	if (f.x > 0.5)  return vec2(-p.z,  p.y);
	if (f.x < -0.5) return vec2( p.z,  p.y);
	if (f.y > 0.5)  return vec2( p.x, -p.z);
	if (f.y < -0.5) return vec2( p.x,  p.z);
	if (f.z > 0.5)  return vec2( p.x,  p.y);
	return vec2(-p.x,  p.y);
}

int face_index(vec3 f) {
	if (f.x > 0.5)  return 0;
	if (f.x < -0.5) return 1;
	if (f.y > 0.5)  return 2;
	if (f.y < -0.5) return 3;
	if (f.z > 0.5)  return 4;
	return 5;
}

void vertex() {
	v_pos = VERTEX;
	v_cam = inverse(MODELVIEW_MATRIX)[3].xyz;
}

void fragment() {
	vec3 ray = normalize(v_pos - v_cam);

	float tx = (ray.x > 0.0) ? (right_depth - v_cam.x) / ray.x : (-left_depth - v_cam.x) / ray.x;
	float ty = (ray.y > 0.0) ? (top_depth - v_cam.y) / ray.y : (-bottom_depth - v_cam.y) / ray.y;
	float tz = (-front_depth - v_cam.z) / ray.z;
	float tz0 = (-layer0_depth - v_cam.z) / ray.z;
	float tz1 = (-layer1_depth - v_cam.z) / ray.z;
	float tz2 = (-layer2_depth - v_cam.z) / ray.z;

	float t = min(min(tx, ty),tz);
	vec3 hit = v_cam + ray * t;
	float t0 = min(min(tx, ty),tz0);
	vec3 hit0 = v_cam + ray * t0;
	float t1 = min(min(tx, ty),tz1);
	vec3 hit1 = v_cam + ray * t1;
	float t2 = min(min(tx, ty),tz2);
	vec3 hit2 = v_cam + ray * t2;

	vec3 face;
	if (t == tx) face = vec3(sign(ray.x), 0.0, 0.0);
	else if (t == ty) face = vec3(0.0, sign(ray.y), 0.0);
	else face = vec3(0.0, 0.0, sign(ray.z));
	
	vec3 face_0;
	if (t0 == tx) face_0 = vec3(sign(ray.x), 0.0, 0.0);
	else if (t0 == ty) face_0 = vec3(0.0, sign(ray.y), 0.0);
	else face_0 = vec3(0.0, 0.0, sign(-ray.z) * 0.5);
	
	vec3 face_1;
	if (t1 == tx) face_1 = vec3(sign(ray.x), 0.0, 0.0);
	else if (t1 == ty) face_1 = vec3(0.0, sign(ray.y), 0.0);
	else face_1 = vec3(0.0, 0.0, sign(-ray.z) * 0.5);
	
	vec3 face_2;
	if (t2 == tx) face_2 = vec3(sign(ray.x), 0.0, 0.0);
	else if (t2 == ty) face_2 = vec3(0.0, sign(ray.y), 0.0);
	else face_2 = vec3(0.0, 0.0, sign(-ray.z) * 0.5);

	vec2 uv = face_uv(hit, face) * 0.5 + 0.5;
	vec2 uv0 = face_uv(hit0, face_0) * 0.5 + 0.5;
	vec2 uv1 = face_uv(hit1, face_1) * 0.5 + 0.5;
	vec2 uv2 = face_uv(hit2, face_2) * 0.5 + 0.5;

	/* FIX: flip both axes */
	uv = vec2(1.0 - uv.x, 1.0 - uv.y);
	uv = clamp(uv, 0.0, 1.0);
	uv0 = vec2(1.0 - uv0.x, 1.0 - uv0.y);
	uv0 = clamp(uv0, 0.0, 1.0);
	uv1 = vec2(1.0 - uv1.x, 1.0 - uv1.y);
	uv1 = clamp(uv1, 0.0, 1.0);
	uv2 = vec2(1.0 - uv2.x, 1.0 - uv2.y);
	uv2 = clamp(uv2, 0.0, 1.0);

	int i = face_index(face);
	vec2 atlas_uv = face_offset[i] + uv * face_size[i];
	int i0 = face_index(face_0);
	vec2 atlas_uv0 = atlas_uv;
	if (i0 == 5) atlas_uv0 = vec2((9.0/6.0),(5.0/6.0)) + uv0 * vec2((2.0/3.0),(2.0/3.0));
	int i1 = face_index(face_1);
	vec2 atlas_uv1 = atlas_uv;
	if (i1 == 5) atlas_uv1 = vec2((5.0/6.0),(5.0/6.0)) + uv1 * vec2((2.0/3.0),(2.0/3.0));
	int i2 = face_index(face_2);
	vec2 atlas_uv2 = atlas_uv;
	if (i2 == 5) atlas_uv2 = vec2((9.0/6.0),(9.0/6.0)) + uv2 * vec2((2.0/3.0),(2.0/3.0));

	// Sample texture and apply brightness
	vec4 base_color = texture(room_atlas, atlas_uv);
	vec4 layer0_color = texture(room_atlas, atlas_uv0);
	vec4 layer1_color = texture(room_atlas, atlas_uv1);
	vec4 layer2_color = texture(room_atlas, atlas_uv2);
	vec4 window_color = texture(room_atlas, vec2(UV.x * (1.0/3.0), UV.y * (1.0/3.0) + (2.0/3.0)));
	
	// Apply brightness control
	vec3 color_0 = layer0_color.rgb * layer0_color.a + base_color.rgb * (1.0 - layer0_color.a);
	vec3 color_1 = layer1_color.rgb * layer1_color.a + color_0 * (1.0 - layer1_color.a);
	vec3 color_2 = layer2_color.rgb * layer2_color.a + color_1 * (1.0 - layer2_color.a);
	vec3 final_color = window_color.rgb * window_color.a + color_2 * (1.0 - window_color.a);
	
	// Clamp to prevent negative values
	final_color = max(final_color, 0.0);
	
	ALBEDO = final_color * brightness;
	//ALPHA = min(base_color.a + layer0_color.a + layer1_color.a + window_color.a, 1.0);
}