extends Node

const CONFIG_PATH = "user://settings.cfg"
var DATA_PATH : String = "user://"
var Sdfgi : bool = false

# Load options
var load_use_sub_threads : bool = false

# In game control
var mouse_sens = 0.4
var auto_pickup : bool = true

var isInGame : bool = false
var playerPos : Vector3
var playerRot : Vector3
var playerTeleported : bool = true

var VRDim : String
var VRPos : Vector3
var VRRot : Vector3

func _ready():
	load_config()
	window_min_limit()
	
#Limit min window size
func window_min_limit():
	DisplayServer.window_set_min_size(Vector2(500,500),0)
	
#Config
func save_config():
	var file = ConfigFile.new()
	file.set_value("game","language",TranslationServer.get_locale())
	file.set_value("game","data_path",DATA_PATH)
	file.set_value("game","load_use_sub_threads",load_use_sub_threads)
	file.set_value("video","fullscreen",DisplayServer.window_get_mode())
	file.set_value("video","scale",get_window().content_scale_factor)
	file.set_value("video","sdfgi",Sdfgi)
	file.set_value("audio","master",AudioServer.get_bus_volume_db(0))
	file.set_value("audio","bgm",AudioServer.get_bus_volume_db(1))
	file.set_value("audio","sfx",AudioServer.get_bus_volume_db(2))
	file.set_value("control","mouse_sens",mouse_sens)
	file.set_value("control","auto_pickup",auto_pickup)
	var err = file.save(CONFIG_PATH)
	if err != OK:	push_error("Fail to save config: %d" % err)
func load_config():
	var file = ConfigFile.new()
	var err = file.load(CONFIG_PATH)
	if err == OK:
		TranslationServer.set_locale(file.get_value("game","language",TranslationServer.get_locale()))
		DATA_PATH = file.get_value("game","data_path","user://")
		load_use_sub_threads = file.get_value("game","load_use_sub_threads",false)
		DisplayServer.window_set_mode(file.get_value("video","fullscreen",DisplayServer.window_get_mode()))
		get_window().content_scale_factor = file.get_value("video","scale",1)
		Sdfgi = file.get_value("video","sdfgi",false)
		AudioServer.set_bus_volume_db(0,file.get_value("audio","master",AudioServer.get_bus_volume_db(0)))
		AudioServer.set_bus_volume_db(1,file.get_value("audio","bgm",AudioServer.get_bus_volume_db(1)))
		AudioServer.set_bus_volume_db(2,file.get_value("audio","sfx",AudioServer.get_bus_volume_db(2)))
		mouse_sens = file.get_value("control","mouse_sens",0.4)
		auto_pickup = file.get_value("control","auto_pickup",true)
	else:			push_warning("Fail to load config: %d" % err)

# Back to title
func back_to_title():
	AHL_LoadManager.load_scene("res://Title/TitleScene.tscn")
	isInGame = false
	
# Get World Path
func get_world_path(dim : String) :
	match dim :
		"Overworld" :	return "res://Assets_Main/World/WorldMain.tscn"
