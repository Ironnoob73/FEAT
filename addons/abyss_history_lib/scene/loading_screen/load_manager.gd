extends Node
## @tutorial(From0): https://forum.godotengine.org/t/how-to-keep-surface-material-override-didnt-change/59110
## @tutorial(From1): https://www.youtube.com/watch?v=Wnkc_qUXYWs

signal progress_changed(progress: float)
signal load_done
signal load_failed(info: String)

var _load_screen: PackedScene =  preload("loading_scene.tscn")
var _replace_main: bool = true
var _loaded_resource : PackedScene
var _scene_path: String
var _progress: Array = []

func load_scene(scene_path: String,
	change_pos: bool = false, pos: Vector3 = Vector3(), change_rot: bool = false, rot: Vector3 = Vector3(),
	replace_main: bool = true) -> void:
	_scene_path = scene_path
	_replace_main = replace_main
	if change_pos:
		Global.set_meta("to_pos", pos)
	if change_rot:
		Global.set_meta("to_rot", rot)
	Global.player_teleported = false
	var loading_screen = _load_screen.instantiate()
	get_tree().get_root().add_child(loading_screen)
	self.progress_changed.connect(loading_screen._update_progress)
	self.load_done.connect(loading_screen._outro)
	self.load_failed.connect(loading_screen._fail)
	start_load()
	
func start_load() -> void:
	var state: Error = ResourceLoader.load_threaded_request(_scene_path, "PackedScene", Global.load_use_sub_threads)
	if state == OK:
		set_process(true)
	else:
		load_failed.emit(str(state, ".", error_string(state)))

func _process(_delta: float) -> void:
	var load_status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(_scene_path, _progress)
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
			if load_status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				load_failed.emit("THREAD_LOAD_INVALID_RESOURCE")
			elif load_status == ResourceLoader.THREAD_LOAD_FAILED:
				load_failed.emit("THREAD_LOAD_FAILED")
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
				Global.set_meta("next_scene",_loaded_resource)
