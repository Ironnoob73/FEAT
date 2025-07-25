extends Area3D

@export var next_scene : String
@export var change_pos : bool = true
@export var pos : Vector3
@export var change_rot : bool = false
@export var rot : Vector3

func _on_body_entered(_body):
	if next_scene:
		AHL_LoadManager.load_scene(LocationPreload.get_path_from_name(next_scene),
			change_pos, pos, change_rot, rot, false)
