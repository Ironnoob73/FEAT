extends Node3D

@onready var cloud_0: MeshInstance3D = $Cloud0
var cloud_0_material: StandardMaterial3D = null
var cloud_0_noise: FastNoiseLite = null
@onready var cloud_1: MeshInstance3D = $Cloud1
var cloud_1_material: StandardMaterial3D = null
var cloud_1_noise: FastNoiseLite = null
@onready var star: MeshInstance3D = $Star
var star_material: StandardMaterial3D = null
var star_noise: FastNoiseLite = null

@onready var sun_axis_z: Node3D = $SunAxisZ
@onready var sun_axis_y: Marker3D = $SunAxisZ/SunAxisY

func _ready() -> void:
	var time_seed: int = int(Time.get_unix_time_from_system())
	
	cloud_0_material = cloud_0.get_surface_override_material(0)
	var cloud_0_texture: NoiseTexture2D = cloud_0_material.albedo_texture
	cloud_0_noise = cloud_0_texture.get_noise()
	cloud_0_noise.seed = time_seed
	
	cloud_1_material = cloud_1.get_surface_override_material(0)
	var cloud_1_texture: NoiseTexture2D = cloud_1_material.albedo_texture
	cloud_1_noise = cloud_1_texture.get_noise()
	cloud_1_noise.seed = time_seed
	
	star_material = star.get_surface_override_material(0)
	var star_texture: NoiseTexture2D = star_material.albedo_texture
	star_noise = star_texture.get_noise()
	star_noise.seed = time_seed
	
func _process(delta: float) -> void:
	if Global.CurrentWorld != null:
		cloud_0_noise.offset += Vector3(delta,delta,delta)
		cloud_1_noise.offset += Vector3(delta/8,delta/8,delta/8)
		star_noise.offset.z += delta / 32
		var day_percent: float = Global.CurrentWorld.day_percent
		if day_percent < 0.5:
			star_material.albedo_color.a = 0
		elif day_percent >= 0.5 and day_percent < 0.6:
			star_material.albedo_color.a = (day_percent - 0.5) / 0.1
		elif day_percent >= 0.6 and day_percent < 0.9:
			star_material.albedo_color.a = 1
			cloud_0_material.albedo_color.r = 0
			cloud_0_material.albedo_color.g = 0
			cloud_0_material.albedo_color.b = 0.5
		elif day_percent >= 0.9:
			star_material.albedo_color.a = 1 - ((day_percent - 0.9) / 0.1)
	
		cloud_0_material.albedo_color = Global.CurrentWorld.ambient_color
		cloud_1_material.albedo_color = cloud_0_material.albedo_color
		
	star.rotate_x(deg_to_rad(0.01))
	star.rotate_y(deg_to_rad(0.01))
	star.rotate_z(deg_to_rad(0.01))

	sun_axis_z.rotation.z = Global.CurrentWorld.sun_axis.rotation.z
	sun_axis_y.rotation.y = Global.CurrentWorld.sun.rotation.y
