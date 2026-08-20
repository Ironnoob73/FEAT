extends Node3D
class_name World

@export var global_time: int = 0
## Half before is day, and after is night?
var day_percent: float = 0
@export var time_speed: int = 1
@export var real_time: bool = true

@onready var player0: LocalPlayer = $Player

@onready var scenes_package: AHL_ScenePackage = $ScenesPackage
@onready var next_scene: Node3D = null

func _ready() -> void:
	Global.current_world = self
	
	_on_options_set_sdfgi(Global.sdfgi)
	var load_request: AHL_LoadRequest = AHL_Core.load_request
	if load_request != null:
		if load_request.tp_change_pos:
			player0.position = load_request.tp_to_pos
			load_request.tp_change_pos = false
		if load_request.tp_change_rot:
			player0.rotation = load_request.tp_to_rot
			load_request.tp_change_rot = false
		AHL_Core.load_request = null
		
	Global.make_world_ready()

func _on_options_set_sdfgi(_value : bool) -> void:
	#if Global.isInGame:
	#	env.environment.set_sdfgi_enabled(value)
	pass

func _physics_process(_delta: float) -> void:
	var load_request: AHL_LoadRequest = AHL_Core.load_request
	if load_request != null and load_request.next_scene:
		scenes_package.queue_free()
		var load_scene: Callable = func() -> void:
			var next_scene_ins: PackedScene = load_request.next_scene
			scenes_package = next_scene_ins.instantiate()
			add_child(scenes_package)
			#if scenes_package.environment != null:
			#	env.environment = scenes_package.environment
			AHL_Core.load_request = null
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
		
func change_scene(location:String,pos:Vector3) -> void:
	match location :
		"":	return
		"null":	return
		"out":
			add_child(scenes_package)
			if next_scene != null:
				remove_child(next_scene)
				next_scene = null
		_ :
			if next_scene == null:
				remove_child(scenes_package)
			else:
				remove_child(next_scene)
			next_scene = scenes_package.room_scenes.get(location)
			add_child(next_scene)
	player0.position = pos

func host(port:int) -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var state: int = peer.create_server(port)
	var chat: PlayerChat = player0.chat_menu
	if state == OK:
		multiplayer.multiplayer_peer = peer
		chat.append_message(str("[World]Host at port successed:", port))
		Global.is_multiplayer = true
	else:
		chat.append_message(str("[World]Host at port failed:", port, state))

func join(address:String,port:int) -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var state: int = peer.create_client(address,port)
	var chat: PlayerChat = player0.chat_menu
	if state == OK:
		multiplayer.multiplayer_peer = peer
		chat.append_message(str("[World]Join successed:", address, ":", port))
		Global.is_multiplayer = true
	else:
		chat.append_message(str("[World]Join Failed:", port, state))
