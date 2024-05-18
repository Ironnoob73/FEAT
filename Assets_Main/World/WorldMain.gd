extends Node3D

var global_time : int = 0
@export var time_speed : int = 1

@onready var env = $WorldEnvironment
@onready var sun_axis = $WorldEnvironment/SunAxis
@onready var sun = $WorldEnvironment/SunAxis/SunLight
@onready var sun_visual = $WorldEnvironment/SunAxis/SunVisual

func _ready():
	_on_options_set_sdfgi(Global.Sdfgi)

func _on_options_set_sdfgi(value : bool):
	if Global.isInGame:
		$WorldEnvironment.environment.set_sdfgi_enabled(value)

func _physics_process(_delta):
	global_time += time_speed
	# Day Circle
	# Time of a day : 129600
	var sunlight = global_time % 129600 / 129600.0 * PI
	var daytime : float = global_time % 129600 / 129600.0
	# Sun
	sun_axis.rotation.z = deg_to_rad( global_time % 129600 / 360.0)
	sun.rotation.y = deg_to_rad( 80 - sin(sunlight * 2) * 30)
	sun_visual.rotation.y = sun.rotation.y
	if sin(sunlight * 2) >= 0 :
		sun.visible = true
		sun.light_energy = sin(sunlight * 2) * 2
		sun_visual.light_energy = sin(sunlight) * 2 + 1
		sun.light_color.g = sin(sunlight + PI / 2) * 0.5 + 0.5
		sun.light_color.b = sin(sunlight + PI / 2) * 0.8 + 0.15
		sun_visual.light_color = sun.light_color
		sun.light_angular_distance = sin(sunlight) * 5
		sun_visual.light_angular_distance = sun.light_angular_distance
		env.environment.sky.sky_material.sun_angle_max = sin(sunlight * 2) * 20 + 10
	elif daytime == 0.75 :
		sun_visual.light_energy = 1
		sun_visual.light_color.g = sin(PI / 2) * 0.5 + 0.5
		sun_visual.light_color.b = sin(PI / 2) * 0.8 + 0.15
		sun_visual.light_angular_distance = 0
	else :
		sun.visible = false
	# Environment
	var noon_color : Color = Color(0.38,0.45,0.55)
	var afternoon_color : Color = Color(0.75,0.25,0.11)
	var midnight_color : Color = Color(0,0.11,0.17)
	var noon_color_h : Color = Color(0.64,0.65,0.67)
	var afternoon_color_h : Color = Color(1,0.62,0.55)
	var midnight_color_h : Color = Color(0.11,0,0.27)
	var bottom_color_d : Color = Color(0.2,0.16,0.13)
	var bottom_color_n : Color = Color(0.01,0.02,0.03)
	# Sky
	if daytime <= 0.125 :
		env.environment.sky.sky_material.sky_top_color =\
		( midnight_color * (0.125 - daytime) + noon_color * (daytime + 0.125) ) * 4
		env.environment.sky.sky_material.sky_horizon_color =\
		( midnight_color_h * (0.125 - daytime) + noon_color_h * (daytime + 0.125) ) * 4
	elif daytime > 0.125 and daytime <= 0.375 :
		env.environment.sky.sky_material.sky_top_color = noon_color
		env.environment.sky.sky_material.sky_horizon_color = noon_color_h
	elif daytime > 0.375 and daytime <= 0.5 :
		env.environment.sky.sky_material.sky_top_color =\
		( noon_color * (0.5 - daytime) + afternoon_color * (daytime - 0.375) ) * 8
		env.environment.sky.sky_material.sky_horizon_color =\
		( noon_color_h * (0.5 - daytime) + afternoon_color_h * (daytime - 0.375) ) * 8
	elif daytime > 0.5 and daytime <= 0.625 :
		env.environment.sky.sky_material.sky_top_color =\
		( afternoon_color * (0.625 - daytime) + midnight_color * (daytime - 0.5) ) * 8
		env.environment.sky.sky_material.sky_horizon_color =\
		( afternoon_color_h * (0.625 - daytime) + midnight_color_h * (daytime - 0.5) ) * 8
	elif daytime > 0.625 and daytime <= 0.875 :
		env.environment.sky.sky_material.sky_top_color = midnight_color
		env.environment.sky.sky_material.sky_horizon_color = midnight_color_h
	elif daytime > 0.875 and daytime <= 1 :
		env.environment.sky.sky_material.sky_top_color =\
		( midnight_color * (1.125 - daytime) + noon_color * (daytime - 0.875) ) * 4
		env.environment.sky.sky_material.sky_horizon_color =\
		( midnight_color_h * (1.125 - daytime) + noon_color_h * (daytime - 0.875) ) * 4
	else :
		env.environment.sky.sky_material.sky_top_color = noon_color
		env.environment.sky.sky_material.sky_horizon_color = noon_color_h
	env.environment.sky.sky_material.ground_horizon_color = env.environment.sky.sky_material.sky_horizon_color
	# Ground
	if daytime <= 0.125 :
		env.environment.sky.sky_material.ground_bottom_color =\
		( bottom_color_n * (0.125 - daytime) + bottom_color_d * (daytime + 0.125) ) * 4
	elif daytime > 0.375 and daytime <= 0.625 :
		env.environment.sky.sky_material.ground_bottom_color =\
		( bottom_color_d * (0.625 - daytime) + bottom_color_n * (daytime - 0.375) ) * 4
	elif daytime > 0.625 and daytime <= 0.875 :
		env.environment.sky.sky_material.ground_bottom_color = bottom_color_n
	elif daytime > 0.875 and daytime <= 1 :
		env.environment.sky.sky_material.ground_bottom_color =\
		( bottom_color_n * (1.125 - daytime) + bottom_color_d * (daytime - 0.875) ) * 4
	else :
		env.environment.sky.sky_material.ground_bottom_color = bottom_color_d
		

func _on_timer_timeout():
	#print(global_time)
	pass
