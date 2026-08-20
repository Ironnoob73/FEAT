class_name AHL_LoadRequest
extends Resource

var scene_path: String = ""
var next_scene: PackedScene = null

var tp_cover: bool = true
var tp_change_pos: bool = false
var tp_to_pos: Vector3 = Vector3.ZERO
var tp_change_rot: bool = false
var tp_to_rot: Vector3 = Vector3.ZERO
var tp_replace_main: bool = false

static func new_loader(path: String) -> AHL_LoadRequest:
	var loading_request: AHL_LoadRequest = AHL_LoadRequest.new()
	loading_request.scene_path = path
	return loading_request
	
	
func start_load() -> AHL_LoadingScene:
	AHL_Core.load_request = self
	var tree: SceneTree = Engine.get_main_loop()
	var loading_scene: AHL_LoadingScene = AHL_LoadingScene.new_loader()
	loading_scene.scene_path = scene_path
	loading_scene.cover = tp_cover
	tree.get_root().add_child(loading_scene)
	loading_scene.start_load.call_deferred()
	return loading_scene
	
	
func cover(state: bool = true) -> AHL_LoadRequest:
	tp_cover = state
	return self
	
func to_pos(pos: Vector3) -> AHL_LoadRequest:
	tp_to_pos = pos
	tp_change_pos = true
	return self
	
func to_rot(rot: Vector3) -> AHL_LoadRequest:
	tp_to_rot = rot
	tp_change_rot = true
	return self
	
func replace_main(state: bool = true) -> AHL_LoadRequest:
	tp_replace_main = state
	return self
