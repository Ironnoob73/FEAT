extends CanvasLayer
class_name AHL_LoadingScene
## @tutorial(YouTube video tutorial reference): https://www.youtube.com/watch?v=Wnkc_qUXYWs

signal progress_changed(progress: float)
signal load_done
signal load_failed(info: String)

var scene_path: String
var cover: bool = true

var _progress: Array = []
var _load_already_done: bool = false

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $Background/ProgressBar
@onready var progress_number: Label = $Background/ProgressNumber

static func new_loader() -> AHL_LoadingScene:
	var loading_scene: AHL_LoadingScene = preload("loading_scene.tscn").instantiate()
	return loading_scene
	
func _ready() -> void:
	var _connect: int
	_connect = progress_changed.connect(_update_progress)
	_connect = load_done.connect(_outro)
	_connect = load_failed.connect(_fail)

func _process(_delta: float) -> void:
	if _load_already_done:
		return
		
	var load_request: AHL_LoadRequest = AHL_Core.load_request
	if load_request == null:
		load_failed.emit("Load request lost!")
		
	var load_status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(scene_path, _progress)
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
			var loaded_resource: PackedScene = ResourceLoader.load_threaded_get(scene_path)
			progress_changed.emit(1.0)
			load_done.emit()
			_load_already_done = true
			if load_request.tp_replace_main:
				var _change: Error = get_tree().change_scene_to_packed(loaded_resource)
			else:
				load_request.next_scene = loaded_resource

func _update_progress(value: float) -> void:
	progress_bar.set_value_no_signal(value)
	progress_number.text = str(value * 100) + "%"

func _outro() -> void:
	if cover:
		animation.play("Outro")
		await Signal(animation, "animation_finished")
	self.queue_free()

func _fail(info: String) -> void:
	progress_number.text = str("ERROR: ", info)
	
	
func start_load() -> void:
	var state: Error = ResourceLoader.load_threaded_request(scene_path, "PackedScene", AHL_Core.load_use_sub_threads)
	if state == OK:
		set_process(true)
	else:
		load_failed.emit(str(state, ".", error_string(state)))
		
	if cover:
		animation.play("Intro")
	
