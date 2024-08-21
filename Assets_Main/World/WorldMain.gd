extends Node3D

@export var global_time : int = 0
@export var time_speed : int = 1

@onready var env = $WorldEnvironment
@onready var sun_axis = $WorldEnvironment/SunAxis
@onready var sun = $WorldEnvironment/SunAxis/SunLight
@onready var sun_visual = $WorldEnvironment/SunAxis/SunVisual

@onready var player = $Player
@onready var background = $FalordMap

func _ready():
	_on_options_set_sdfgi(Global.Sdfgi)
	if !Global.playerTeleported :
		player.position = Global.playerPos
		player.rotation = Global.playerRot
		Global.playerTeleported = true

func _on_options_set_sdfgi(value : bool):
	if Global.isInGame:
		$WorldEnvironment.environment.set_sdfgi_enabled(value)

func _physics_process(_delta):
	global_time += time_speed
	# Day Circle
	# Time of a day : 129600
	var sunlight = (global_time - 32400) % 129600 / 129600.0 * PI
	var daytime : float = (global_time - 32400) % 129600 / 129600.0
	# Sun
	sun_axis.rotation.z = deg_to_rad((global_time - 32400) % 129600 / 360.0)
	sun.rotation.y = deg_to_rad( 80 - sin(sunlight * 2) * 30)
	sun_visual.rotation.y = sun.rotation.y
	if sin(sunlight * 2) >= 0 :
		sun.visible = true
		sun.light_energy = sin(sunlight * 2) * 2
		sun.light_color.g = sin(sunlight + PI / 2) * 0.5 + 0.5
		sun.light_color.b = sin(sunlight + PI / 2) * 0.8 + 0.15
		sun_visual.light_color = sun.light_color
		sun.light_angular_distance = sin(sunlight) * 5
		sun_visual.light_angular_distance = sun.light_angular_distance
	elif daytime == 0.75 :
		sun_visual.light_energy = 1
		sun_visual.light_color.g = sin(PI / 2) * 0.5 + 0.5
		sun_visual.light_color.b = sin(PI / 2) * 0.8 + 0.15
		sun_visual.light_angular_distance = 0
	else :
		sun.visible = false
		
#func _process(delta: float) -> void:
	#background.position.x = player.position.x - (player.position.x + 4352)/12288
	#background.position.y = player.position.y - player.position.y/12288 + 0.5
	#background.position.z = player.position.z - (player.position.z - 4352)/12288
	
