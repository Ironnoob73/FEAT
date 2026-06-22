extends Node

@onready var camera_3d: Camera3D = $"../CameraPose/Camera3D"

func _process(_delta: float) -> void:
	var parent_computer: AHL_Interactive = get_parent()
	if parent_computer.user != null and parent_computer.user is LocalPlayer:
		Global.CurrentWorld.player0.lerp_cam.global_transform = camera_3d.global_transform
