extends Node
## @tutorial(From0): https://forum.godotengine.org/t/how-to-keep-surface-material-override-didnt-change/59110
## @tutorial(From1): https://www.youtube.com/watch?v=Wnkc_qUXYWs

signal progress_changed(progress)
signal load_done

var _load_screen =  preload("loading_scene.tscn")
var _replace_main = true
var _loaded_resource : PackedScene
var _scene_path : String
var _progress : Array = []

func load_scene(scene_path : String,
	change_pos = false, pos = Vector3(), change_rot = false, rot = Vector3(), replace_main = true):
	_scene_path = scene_path
	_replace_main = replace_main
	Global.playerWillPos = change_pos
	Global.playerWillRot = change_rot
	if pos:
		Global.playerPos = pos
		Global.playerTeleported = false
	if rot:
		Global.playerRot = rot
	var loading_screen = _load_screen.instantiate()
	get_tree().get_root().add_child(loading_screen)
	self.progress_changed.connect(loading_screen._update_progress)
	self.load_done.connect(loading_screen._outro)
	start_load()
	
func start_load():
	var state = ResourceLoader.load_threaded_request(_scene_path, "PackedScene", Global.load_use_sub_threads)
	if state == OK:
		set_process(true)

func _process(_delta):
	var load_status = ResourceLoader.load_threaded_get_status(_scene_path, _progress)
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE,ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_changed.emit(_progress[0])
		ResourceLoader.THREAD_LOAD_LOADED:
			_loaded_resource = ResourceLoader.load_threaded_get(_scene_path)
			progress_changed.emit(1.0)
			load_done.emit()
			if _replace_main:
				get_tree().change_scene_to_packed(_loaded_resource)
			else:
				Global.next_scene_package = _loaded_resource
