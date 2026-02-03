extends Node3D
class_name World

@export var global_time: int = 0
## Half before is day, and after is night?
var day_percent: float = 0
@export var time_speed: int = 1
@export var real_time: bool = true

@onready var player0: LocalPlayer = $Player

@onready var SCENES_PACKAGE: AHL_ScenePackage = $ScenesPackage
@onready var next_scene: Node3D = null

@onready var env: WorldEnvironment = $WorldEnvironment
@onready var sun_axis: Node3D = $WorldEnvironment/SunAxis
@onready var sun: DirectionalLight3D = $WorldEnvironment/SunAxis/SunLight
@onready var sun_visual: DirectionalLight3D = $WorldEnvironment/SunAxis/SunVisual

var ambient_color: Color = Color(0,0,0)

var day_top_color: Color = Color("61738c")
var day_bottom_color: Color = Color("a3a6ab")
var sunset_top_color: Color = Color("bd7d1a")
var sunset_bottom_color: Color = Color("ff9e8c")
var night_top_color: Color = Color("001c2b")
var night_bottom_color: Color = Color("030508")

func _ready() -> void:
	Global.CurrentWorld = self
	
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
		var load_scene: Callable = func() -> void:
			var next_scene_ins: PackedScene = Global.get_meta("next_scene")
			SCENES_PACKAGE = next_scene_ins.instantiate()
			add_child(SCENES_PACKAGE)
			if SCENES_PACKAGE.environment != null:
				env.environment = SCENES_PACKAGE.environment
			Global.remove_meta("next_scene")
		load_scene.call_deferred()
		_ready()
	if !real_time:
		global_time += time_speed
	# Day Circle
	# Time of a day : 129600
	if !real_time:
		day_percent = (global_time - 32400) % 129600 / 129600.0
	else:
		var time_dict: Dictionary = Time.get_time_dict_from_system()
		var hour_convert: int = time_dict.get("hour") - 8
		if hour_convert < 0:
			hour_convert += 24
		day_percent = (
			hour_convert * 3600 + 
			time_dict.get("minute") * 60 + 
			time_dict.get("second")) / 86400.0
		
func _process(_delta: float) -> void:
	var sunlight: float = day_percent * PI
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
	# Ambient Color
	var day_offset: float = 0
	if day_percent >= 0.25:
		day_offset = day_percent - 0.25
	else:
		day_offset = day_percent + 0.75
	if day_offset <= 0.25:
		ambient_color.r = 0.63 + (0.37 * day_offset * 4)
		ambient_color.g = 0.64 - (0.02 * day_offset * 4)
		ambient_color.b = 0.67 - (0.12 * day_offset * 4)
	elif day_offset > 0.25 and day_offset <= 0.3:
		ambient_color.r = 1 - (1 * (day_offset - 0.25) * 20)
		ambient_color.g = 0.62 - (0.52 * (day_offset - 0.25) * 20)
		ambient_color.b = 0.55 - (0.38 * (day_offset - 0.25) * 20)
	elif day_offset > 0.3 and day_offset <= 0.75:
		ambient_color = Color(0,0.1,0.17)
	elif day_offset > 0.75:
		ambient_color.r = 0.63 * (day_offset - 0.75) * 4
		ambient_color.g = 0.1 + (0.54 * (day_offset - 0.75) * 4)
		ambient_color.b = 0.17 + (0.5 * (day_offset - 0.75) * 4)
	
	var current_env: Environment = env.get_environment()
	var current_sky: Sky = current_env.get_sky()
	if current_sky.get_material() is ProceduralSkyMaterial and real_time:
		var current_sky_material: ProceduralSkyMaterial = current_sky.get_material()
		current_sky_material.ground_horizon_color = current_sky_material.sky_horizon_color
		current_sky_material.ground_bottom_color = ambient_color
		if day_offset <= 0.25:
			current_sky_material.sky_top_color = day_top_color + ((sunset_top_color - day_top_color) * (day_offset / 0.25))
			current_sky_material.sky_horizon_color = day_bottom_color + ((sunset_bottom_color - day_bottom_color) * (day_offset / 0.25))
		elif day_offset > 0.25 and day_offset <= 0.3:
			current_sky_material.sky_top_color = sunset_top_color + ((night_top_color - sunset_top_color) * ((day_offset - 0.25) / 0.05))
			current_sky_material.sky_horizon_color = sunset_bottom_color + ((night_bottom_color - sunset_bottom_color) * ((day_offset - 0.25) / 0.05))
		elif day_offset > 0.3 and day_offset <= 0.75:
			current_sky_material.sky_top_color = night_top_color
			current_sky_material.sky_horizon_color = night_bottom_color
		elif day_offset > 0.75:
			current_sky_material.sky_top_color = night_top_color + ((day_top_color - night_top_color) * ((day_offset - 0.75) / 0.25))
			current_sky_material.sky_horizon_color = night_bottom_color + ((day_bottom_color - night_bottom_color) * ((day_offset - 0.75) / 0.25))
			
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

func host(port:int) -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var state: int = peer.create_server(port)
	var chat: PlayerChat = player0.chat_menu
	if state == OK:
		multiplayer.multiplayer_peer = peer
		chat.append_message(str("[World]Host at port successed:", port))
		Global.isMultiplayer = true
	else:
		chat.append_message(str("[World]Host at port failed:", port, state))

func join(address:String,port:int) -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var state: int = peer.create_client(address,port)
	var chat: PlayerChat = player0.chat_menu
	if state == OK:
		multiplayer.multiplayer_peer = peer
		chat.append_message(str("[World]Join successed:", address, ":", port))
		Global.isMultiplayer = true
	else:
		chat.append_message(str("[World]Join Failed:", port, state))
