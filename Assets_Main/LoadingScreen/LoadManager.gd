extends Node
#from : https://www.youtube.com/watch?v=Wnkc_qUXYWs

signal progress_changed(progress)
signal load_done

var _load_screen_path : String = "res://Assets_Main/LoadingScreen/loading_scene.tscn"
var _load_screen = load(_load_screen_path)
var _loaded_resource : PackedScene
var _scene_path : String
var _progress : Array = []

var use_sub_threads : bool = false

func load_scene(scene_path : String , pos = null , rot = null):
	_scene_path = scene_path
	if pos :
		Global.playerPos = pos
		Global.playerRot = rot
		Global.playerTeleported = false
	var loading_screen = _load_screen.instantiate()
	get_tree().get_root().add_child(loading_screen)
	self.progress_changed.connect(loading_screen._update_progress)
	self.load_done.connect(loading_screen._outro)
	start_load()
	
func start_load():
	var state = ResourceLoader.load_threaded_request(_scene_path, "PackedScene", use_sub_threads)
	if state == OK:
		set_process(true)

func _process(_delta):
	var load_status = ResourceLoader.load_threaded_get_status(_scene_path, _progress)
	match load_status:
		0,2:
			set_process(false)
			return
		1:
			emit_signal("progress_changed", _progress[0])
		3:
			_loaded_resource = ResourceLoader.load_threaded_get(_scene_path)
			emit_signal("progress_changed", 1.0)
			emit_signal("load_done")
			get_tree().change_scene_to_packed(_loaded_resource)
