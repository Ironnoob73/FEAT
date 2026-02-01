extends SubViewport

@onready var bg_cam: Camera3D = $BgCam
@onready var world0: Node3D = $"../../../"
@onready var falord_map: MeshInstance3D = $FalordMap

func _ready() -> void:
	falord_map.show()

func _process(_delta: float) -> void:
	size = get_window().size
	bg_cam.global_position = (Global.CurrentWorld.player0.first_person_cam.global_position + Vector3(4352,0,-4352)) / 12288
	bg_cam.global_rotation = Global.CurrentWorld.player0.first_person_cam.global_rotation
	@warning_ignore("unsafe_property_access")
	world_3d.environment.ambient_light_color = world0.ambient_color
