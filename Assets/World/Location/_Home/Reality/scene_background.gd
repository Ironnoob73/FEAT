extends Node3D

@onready var cloud_0: MeshInstance3D = $Cloud0
@onready var cloud_1: MeshInstance3D = $Cloud1
@onready var star: MeshInstance3D = $Star

@onready var sun_axis: Node3D = $SunAxis

func _process(delta: float) -> void:
	var cloud_0_material: StandardMaterial3D = cloud_0.get_surface_override_material(0)
	var cloud_0_texture: NoiseTexture2D = cloud_0_material.albedo_texture
	var cloud_0_noise: FastNoiseLite = cloud_0_texture.get_noise()
	cloud_0_noise.offset += Vector3(delta,delta,delta)
	var cloud_1_material: StandardMaterial3D = cloud_1.get_surface_override_material(0)
	var cloud_1_texture: NoiseTexture2D = cloud_1_material.albedo_texture
	var cloud_1_noise: FastNoiseLite = cloud_1_texture.get_noise()
	cloud_1_noise.offset += Vector3(delta/8,delta/8,delta/8)
	var star_material: StandardMaterial3D = star.get_surface_override_material(0)
	var star_texture: NoiseTexture2D = star_material.albedo_texture
	var star_noise: FastNoiseLite = star_texture.get_noise()
	star_noise.offset.z += delta / 32
	star.rotate_x(deg_to_rad(0.01))
	star.rotate_y(deg_to_rad(0.01))
	star.rotate_z(deg_to_rad(0.01))
