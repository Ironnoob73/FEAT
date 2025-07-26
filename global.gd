extends Node

const CONFIG_PATH = "user://settings.cfg"
const KEYBINDINGS_PATH = "user://keybindings.cfg"
var DATA_PATH : String = "user://"
var Sdfgi : bool = false

# Load options
var load_use_sub_threads : bool = false

# In game control
var mouse_sens = 0.4
var auto_pickup : bool = true

var isInGame : bool = false
var playerTeleported : bool = true

var VRDim : String
var VRPos : Vector3
var VRRot : Vector3

# Debug
var printDebugInfo : bool = false
var catchPElemIssue : bool = false
var alwaysShowCursor : bool = false

func _ready():
	load_config()
	window_min_limit()
	
## Limit min window size.
func window_min_limit():
	DisplayServer.window_set_min_size(Vector2(500,500),0)
	
## Save the config by creating a new file.
func save_config():
	var file = ConfigFile.new()
	file.set_value("game","language",TranslationServer.get_locale())
	file.set_value("game","data_path",DATA_PATH)
	file.set_value("game","load_use_sub_threads",load_use_sub_threads)
	file.set_value("game","print_debug_info",printDebugInfo)
	file.set_value("game","catch_p_null_issue",catchPElemIssue)
	file.set_value("game","always_show_cursor",alwaysShowCursor)
	file.set_value("video","fullscreen",DisplayServer.window_get_mode())
	file.set_value("video","scale",get_window().content_scale_factor)
	file.set_value("video","sdfgi",Sdfgi)
	file.set_value("audio","master",AudioServer.get_bus_volume_db(0))
	file.set_value("audio","bgm",AudioServer.get_bus_volume_db(1))
	file.set_value("audio","sfx",AudioServer.get_bus_volume_db(2))
	file.set_value("control","mouse_sens",mouse_sens)
	file.set_value("control","auto_pickup",auto_pickup)
	var err = file.save(CONFIG_PATH)
	if err != OK:
		push_error("Fail to save config: %d" % err)

func load_config():
	var file = ConfigFile.new()
	var err = file.load(CONFIG_PATH)
	if err == OK:
		TranslationServer.set_locale(file.get_value("game","language",TranslationServer.get_locale()))
		DATA_PATH = file.get_value("game","data_path","user://")
		load_use_sub_threads = file.get_value("game","load_use_sub_threads",false)
		printDebugInfo = file.get_value("game","print_debug_info",false)
		catchPElemIssue = file.get_value("game","catch_p_null_issue",false)
		alwaysShowCursor = file.get_value("game","always_show_cursor",false)
		DisplayServer.window_set_mode(file.get_value("video","fullscreen",DisplayServer.window_get_mode()))
		get_window().content_scale_factor = file.get_value("video","scale",1)
		Sdfgi = file.get_value("video","sdfgi",false)
		AudioServer.set_bus_volume_db(0,file.get_value("audio","master",AudioServer.get_bus_volume_db(0)))
		AudioServer.set_bus_volume_db(1,file.get_value("audio","bgm",AudioServer.get_bus_volume_db(1)))
		AudioServer.set_bus_volume_db(2,file.get_value("audio","sfx",AudioServer.get_bus_volume_db(2)))
		mouse_sens = file.get_value("control","mouse_sens",0.4)
		auto_pickup = file.get_value("control","auto_pickup",true)
	else:
		push_warning("Fail to load config: %d" % err)
		
func save_settings_to_file(section: String, key: String, value: Variant) -> void:
	var file = ConfigFile.new()
	var err = file.load(CONFIG_PATH)
	if err == OK:
		file.set_value(section, key, value)
		var err_s = file.save(CONFIG_PATH)
		if err_s != OK:
			push_error("Fail to save config: %d" % err)
	else:
		push_warning("Fail to load config: %d" % err)
		save_config()

func load_settings_from_file(section: String, key: String, default_value: Variant):
	var file = ConfigFile.new()
	var err = file.load(CONFIG_PATH)
	if err == OK:
		return file.get_value(section,key,default_value)
	else:
		push_warning("Fail to load config: %d" % err)
		return default_value
		
# For Keybindings
func get_key_array(action: String) -> Array:
	var key_array : Array = []
	for i in InputMap.action_get_events(action):
		if i is InputEventKey:
			key_array.append(i.as_text())
	return key_array
	
func get_key_event_array(action: String) -> Array:
	var key_array : Array = []
	for i in InputMap.action_get_events(action):
		key_array.append(i)
	return key_array
	
## Back to title
func back_to_title():
	AHL_LoadManager.load_scene("res://Title/TitleScene.tscn")
	isInGame = false
	
## Get World Path
func get_world_path(dim : String) :
	match dim :
		"Overworld" :	return "res://Assets/World/WorldMain.tscn"

## When "p->elem" issue happened, use this to print tons of text.
func p_elem_debug(info : String) :
	if catchPElemIssue:
		push_warning(info)
		
