extends Node3D

@export var global_time: int = 0
var day_percent: float = 0 
@export var time_speed: int = 1

@onready var player0 = $Player
#@onready var background = $FalordMap

@onready var SCENES_PACKAGE: Node3D = $ScenesPackage
@onready var next_scene: Node3D = null

@onready var env: WorldEnvironment = $WorldEnvironment
@onready var sun_axis = $WorldEnvironment/SunAxis
@onready var sun = $WorldEnvironment/SunAxis/SunLight
@onready var sun_visual = $WorldEnvironment/SunAxis/SunVisual

var ambient_color: Color = Color(0,0,0)

func _ready() -> void:
	_on_options_set_sdfgi(Global.Sdfgi)
	if !Global.playerTeleported :
		if Global.has_meta("to_pos"):
			player0.position = Global.get_meta("to_pos")
			Global.remove_meta("to_pos")
		if Global.has_meta("to_rot"):
			player0.rotation = Global.get_meta("to_rot")
			Global.remove_meta("to_rot")
		Global.playerTeleported = true

func _on_options_set_sdfgi(value : bool) -> void:
	if Global.isInGame:
		env.environment.set_sdfgi_enabled(value)

func _physics_process(_delta: float) -> void:
	if Global.has_meta("next_scene"):
		SCENES_PACKAGE.queue_free()
		var load_scene = func():
			SCENES_PACKAGE= Global.get_meta("next_scene").instantiate()
			add_child(SCENES_PACKAGE)
			Global.remove_meta("next_scene")
		load_scene.call_deferred()
		_ready()
	global_time += time_speed
	# Day Circle
	# Time of a day : 129600
	day_percent = (global_time - 32400) % 129600 / 129600.0
		
func _process(_delta: float) -> void:
	var sunlight = day_percent * PI
	# Sun
	sun_axis.rotation.z = deg_to_rad(day_percent * 360.0)
	sun.rotation.y = deg_to_rad(80 - sin(sunlight * 2) * 30)
	sun_visual.rotation.y = sun.rotation.y
	if sin(sunlight * 2) >= 0 :
		sun.visible = true
		sun.light_energy = sin(sunlight * 2) * 2
		sun.light_color.g = sin(sunlight + PI / 2) * 0.5 + 0.5
		sun.light_color.b = sin(sunlight + PI / 2) * 0.8 + 0.15
		sun_visual.light_color = sun.light_color
		sun.shadow_blur = sin(sunlight) * 5
		sun_visual.light_angular_distance = sin(sunlight) * 5
	elif day_percent == 0.75 :
		sun_visual.light_energy = 1
		sun_visual.light_color.g = sin(PI / 2) * 0.5 + 0.5
		sun_visual.light_color.b = sin(PI / 2) * 0.8 + 0.15
		sun_visual.light_angular_distance = 0
	else :
		sun.visible = false
	# Reflected
	if day_percent < 0.5:
		env.environment.reflected_light_source = Environment.REFLECTION_SOURCE_BG
	else:
		env.environment.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	# Ambient Color
	var day_offset: float = 0
	if day_percent >= 0.2:
		day_offset = day_percent - 0.2
	else:
		day_offset = day_percent + 0.8
	if day_offset <= 0.25:
		ambient_color.r = 0.63 + (0.37 * day_offset * 4)
		ambient_color.g = 0.64 - (0.02 * day_offset * 4)
		ambient_color.b = 0.67 - (0.12 * day_offset * 4)
	elif day_offset > 0.25 and day_offset <= 0.3:
		ambient_color.r = 1 - (1 * (day_offset - 0.25) * 20)
		ambient_color.g = 0.62 - (0.52 * (day_offset - 0.25) * 20)
		ambient_color.b = 0.55 - (0.38 * (day_offset - 0.25) * 20)
	elif day_offset > 0.75 and day_offset <= 1:
		ambient_color.r = 0.63 * (day_offset - 0.75) * 4
		ambient_color.g = 0.1 + (0.54 * (day_offset - 0.75) * 4)
		ambient_color.b = 0.17 + (0.5 * (day_offset - 0.75) * 4)
	
func change_scene(location:String,pos:Vector3) -> void:
	match location :
		"":	return
		"null":	return
		"out":
			add_child(SCENES_PACKAGE)
			if next_scene != null:
				remove_child(next_scene)
				next_scene = null
		_ :
			if next_scene == null:
				remove_child(SCENES_PACKAGE)
			else:
				remove_child(next_scene)
			next_scene = SCENES_PACKAGE.room_scenes.get(location)
			add_child(next_scene)
	player0.position = pos
