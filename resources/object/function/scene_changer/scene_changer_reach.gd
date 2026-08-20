extends Area3D

@export var next_scene : String
@export var change_pos : bool = true
@export var pos : Vector3
@export var change_rot : bool = false
@export var rot : Vector3

func _on_body_entered(body: Node3D) -> void:
	if next_scene and body is LocalPlayer:
		var load_request: AHL_LoadRequest =\
				AHL_LoadRequest.new_loader(LocationList.get_path_from_name(next_scene))
		if change_pos:
			load_request = load_request.to_pos(pos)
		if change_rot:
			load_request = load_request.to_rot(rot)
		var _loading_scene: AHL_LoadingScene = load_request.start_load()
