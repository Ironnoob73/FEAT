extends SubViewport
class_name sub_room_viewport
## For a portal-like visual correction.

@onready var camera_3d: Camera3D = $Camera3D

func _process(_delta: float) -> void:
	size = get_window().size
	var player_cam: Camera3D = Global.current_world.player0.first_person_cam
	camera_3d.global_position = player_cam.global_position
	camera_3d.global_rotation = player_cam.global_rotation
	
