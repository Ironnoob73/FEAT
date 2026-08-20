class_name GlobalNode
extends Node

const CONFIG_PATH: String = "user://settings.cfg"
var language_list: Array[String] = ["en_US","zh_CN"]
var data_path: String = "user://"
var sdfgi: bool = false

var fast_boot: bool = false
var oobe: bool = true

# Important objects
# But now will load from the Main World
# var THE_PLAYER: LocalPlayer = null
var current_world: World = null
# Gameflow Control
var launch_ready: bool = false

# UI Control
var block_escape: bool = false
var current_menu: String = "null"

# In game control
var mouse_sens: float = 0.4
var auto_pickup: bool = true

var playerName: String = "Anonymous":
	set(name_string):
		playerName = name_string
		if current_world != null and current_world.player0 != null:
			current_world.player0.player_name = name_string
var duid: String = "00000000-0000-9000-0000-000000000000"
var portrait: Texture2D = preload("res://resources/image/portrait/default.png")
var is_in_game: bool = false
var is_multiplayer: bool = false

var vr_dim: String
var vr_pos: Vector3
var vr_rot: Vector3

# Debug
var print_debug_info: bool = false
var catch_p_elem_issue: bool = false
var always_show_cursor: bool = false

signal world_ready

func _ready() -> void:
	load_config()
	window_min_limit()
	
func make_world_ready() -> void:
	world_ready.emit()
	
## Limit min window size.
func window_min_limit() -> void:
	DisplayServer.window_set_min_size(Vector2(500,500),0)
	
## Save the config by creating a new file.
func save_config() -> void:
	var file: ConfigFile = ConfigFile.new()
	file.set_value("game","language",TranslationServer.get_locale())
	file.set_value("game","data_path",data_path)
	file.set_value("game","load_use_sub_threads",AHL_Core.load_use_sub_threads)
	file.set_value("game","print_debug_info",print_debug_info)
	file.set_value("game","catch_p_null_issue",catch_p_elem_issue)
	file.set_value("game","always_show_cursor",always_show_cursor)
	file.set_value("video","fullscreen",DisplayServer.window_get_mode())
	file.set_value("video","scale",get_window().content_scale_factor)
	file.set_value("video","sdfgi",sdfgi)
	file.set_value("audio","master",AudioServer.get_bus_volume_db(0))
	file.set_value("audio","bgm",AudioServer.get_bus_volume_db(1))
	file.set_value("audio","sfx",AudioServer.get_bus_volume_db(2))
	file.set_value("control","mouse_sens",mouse_sens)
	file.set_value("control","auto_pickup",auto_pickup)
	file.set_value("profile","user_name",playerName)
	file.set_value("profile","user_duid",duid)
	file.set_value("profile","user_portrait",portrait)
	file.set_value("computer","fast_boot",fast_boot)
	file.set_value("computer","oobe",oobe)
	var err: Error = file.save(CONFIG_PATH)
	if err != OK:
		push_error("Fail to save config: %d" % err)

func load_config() -> void:
	var file: ConfigFile = ConfigFile.new()
	var err: Error = file.load(CONFIG_PATH)
	if err == OK:
		var locate_value: String = file.get_value("game","language",TranslationServer.get_locale())
		TranslationServer.set_locale(locate_value)
		data_path = file.get_value("game","data_path","user://")
		AHL_Core.load_use_sub_threads = file.get_value("game","load_use_sub_threads",false)
		print_debug_info = file.get_value("game","print_debug_info",false)
		catch_p_elem_issue = file.get_value("game","catch_p_null_issue",false)
		always_show_cursor = file.get_value("game","always_show_cursor",false)
		var window_mode: int = file.get_value("video","fullscreen",DisplayServer.window_get_mode())
		DisplayServer.window_set_mode(window_mode)
		get_window().content_scale_factor = file.get_value("video","scale",1)
		sdfgi = file.get_value("video","sdfgi",false)
		var master_volume: float = file.get_value("audio","master",AudioServer.get_bus_volume_db(0))
		AudioServer.set_bus_volume_db(0, master_volume)
		var bgm_volume: float = file.get_value("audio","bgm",AudioServer.get_bus_volume_db(1))
		AudioServer.set_bus_volume_db(1, bgm_volume)
		var sfx_volume: float = file.get_value("audio","sfx",AudioServer.get_bus_volume_db(2))
		AudioServer.set_bus_volume_db(2, sfx_volume)
		mouse_sens = file.get_value("control","mouse_sens",0.4)
		auto_pickup = file.get_value("control","auto_pickup",true)
		playerName = file.get_value("profile","user_name","Anonymous")
		duid = file.get_value("profile","user_duid","00000000-0000-9000-0000-000000000000")
		portrait = file.get_value("profile","user_portrait",preload("res://resources/image/portrait/default.png"))
		fast_boot = file.get_value("computer","fast_boot",false)
		oobe = file.get_value("computer","oobe",true)
	else:
		push_warning("Fail to load config: %d" % err)
		
func save_settings_to_file(section: String, key: String, value: Variant) -> void:
	var file: ConfigFile = ConfigFile.new()
	var err: Error = file.load(CONFIG_PATH)
	if err == OK:
		file.set_value(section, key, value)
		var err_s: Error = file.save(CONFIG_PATH)
		if err_s != OK:
			push_error("Fail to save config: %d" % err)
	else:
		push_warning("Fail to load config: %d" % err)
		save_config()

func load_settings_from_file(section: String, key: String, default_value: Variant) -> Variant:
	var file: ConfigFile = ConfigFile.new()
	var err: Error = file.load(CONFIG_PATH)
	if err == OK:
		return file.get_value(section,key,default_value)
	else:
		push_warning("Fail to load config: %d" % err)
		return default_value
		
# For Keybindings
func get_key_array(action: String) -> Array:
	var key_array : Array = []
	for i: InputEvent in InputMap.action_get_events(action):
		if i is InputEventKey:
			key_array.append(i.as_text())
	return key_array
	
func get_key_event_array(action: String) -> Array:
	var key_array : Array = []
	for i: InputEvent in InputMap.action_get_events(action):
		key_array.append(i)
	return key_array
	
## Back to title
func back_to_title() -> void:
	var _loading_scene: AHL_LoadingScene =\
			AHL_LoadRequest.new_loader("res://title/title_scene.tscn").replace_main().start_load()
	is_in_game = false
	
## Get World Path
func get_world_path(dim : String) -> String:
	match dim :
		_:	return "res://assets/world/world_main.tscn"

## When "p->elem" issue happened, use this to print tons of text.
func p_elem_debug(info : String) -> void:
	if catch_p_elem_issue:
		push_warning(info)
		
## If the OS Language is supported.
func is_os_language_supported() -> bool:
	return language_list.has(OS.get_locale())
	
# Multiplayer
func host(port:int) -> void:
	if is_in_game and get_node("/root/World") is World:
		var world: World = get_node("/root/World")
		world.host(port)

func join(address:String,port:int) -> void:
	if is_in_game and get_node("/root/World") is World:
		var world: World = get_node("/root/World")
		world.join(address,port)

# DUID
## Like UUID but not.
func generate_duid(variant: int = 0) -> String:
	var time: String = "%011X" % (Time.get_unix_time_from_system() * 1000)
	var launch: String = "%04X" % Time.get_ticks_msec()
	var bias: String = "%03X" % (Time.get_time_zone_from_system()["bias"] + 1440)
	var variantf: String = "%X" % variant
	var uid: String = "%016X" % ResourceUID.create_id()
	return str(time.substr(0,8),"-",\
	time.substr(8,3),launch.substr(launch.length()-1),"-9",\
	bias,"-",\
	variantf.substr(variantf.length()-1),uid.substr(1,3),"-",\
	uid.substr(4,12))
