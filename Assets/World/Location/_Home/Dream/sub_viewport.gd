extends SubViewport

func _ready() -> void:
	size = get_window().size

func _process(_delta: float) -> void:
	$Camera3D.global_position = Global.CurrentWorld.player0.first_person_cam.global_position
	$Camera3D.global_rotation = Global.CurrentWorld.player0.first_person_cam.global_rotation
