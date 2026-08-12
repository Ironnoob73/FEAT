extends CanvasLayer
class_name AHL_LoadingScene
## @tutorial(YouTube video tutorial reference): https://www.youtube.com/watch?v=Wnkc_qUXYWs

signal progress_changed(progress: float)
signal load_done
signal load_failed(info: String)

var _scene_path: String
var _cover: bool = true
var _change_pos: bool = false
var _to_pos: Vector3 = Vector3.ZERO
var _change_rot: bool = false
var _to_rot: Vector3 = Vector3.ZERO
var _replace_main: bool = true

var _loaded_resource : PackedScene
var _progress: Array = []
var _load_already_done: bool = false

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $Background/ProgressBar
@onready var progress_number: Label = $Background/ProgressNumber

static func new_loader(path: String) -> AHL_LoadingScene:
	var loading_scene: AHL_LoadingScene = preload("loading_scene.tscn").instantiate()
	loading_scene._scene_path = path
	return loading_scene
	
func _ready() -> void:
	var _connect: int
	_connect = progress_changed.connect(_update_progress)
	_connect = load_done.connect(_outro)
	_connect = load_failed.connect(_fail)

func _process(_delta: float) -> void:
	if _load_already_done:
		return
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
			_load_already_done = true
			if _replace_main:
				var _change: Error = get_tree().change_scene_to_packed(_loaded_resource)
			else:
				Global.set_meta("next_scene",_loaded_resource)

func _update_progress(value: float) -> void:
	progress_bar.set_value_no_signal(value)
	progress_number.text = str(value * 100) + "%"

func _outro() -> void:
	if _cover:
		animation.play("Outro")
		await Signal(animation, "animation_finished")
	self.queue_free()

func _fail(info: String) -> void:
	progress_number.text = str("ERROR: ", info)
	
	
func start_load() -> void:
	Global.player_teleported = false
	if _change_pos:
		Global.set_meta("to_pos", _to_pos)
	if _change_rot:
		Global.set_meta("to_rot", _to_rot)
	var tree: SceneTree = Engine.get_main_loop()
	tree.get_root().add_child(self)
	
	var state: Error = ResourceLoader.load_threaded_request(_scene_path, "PackedScene", Global.load_use_sub_threads)
	if state == OK:
		set_process(true)
	else:
		load_failed.emit(str(state, ".", error_string(state)))
		
	if _cover:
		animation.play()
	
	
func cover(state: bool = true) -> AHL_LoadingScene:
	_cover = state
	return self
	
func to_pos(pos: Vector3) -> AHL_LoadingScene:
	_to_pos = pos
	_change_pos = true
	return self
	
func to_rot(rot: Vector3) -> AHL_LoadingScene:
	_to_rot = rot
	_change_rot = true
	return self
	
func replace_main(state: bool = true) -> AHL_LoadingScene:
	_replace_main = state
	return self
