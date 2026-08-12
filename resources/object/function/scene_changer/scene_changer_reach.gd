extends Area3D

@export var next_scene : String
@export var change_pos : bool = true
@export var pos : Vector3
@export var change_rot : bool = false
@export var rot : Vector3

func _on_body_entered(body: Node3D) -> void:
	if next_scene and body is LocalPlayer:
		var loading_scene: AHL_LoadingScene =\
			AHL_LoadingScene.new_loader(LocationList.get_path_from_name(next_scene)).replace_main(false)
		if change_pos:
			loading_scene = loading_scene.to_pos(pos)
		if change_rot:
			loading_scene = loading_scene.to_rot(rot)
		loading_scene.start_load()
