extends SubViewport
class_name sub_room_viewport

@onready var camera_3d: Camera3D = $Camera3D
@export var environment: Environment

func _ready() -> void:
	if environment:
		world_3d = World3D.new()
		world_3d.environment = environment

func _process(_delta: float) -> void:
	size = get_window().size
	var player_cam: Camera3D = Global.CurrentWorld.player0.first_person_cam
	camera_3d.global_position = player_cam.global_position
	camera_3d.global_rotation = player_cam.global_rotation
