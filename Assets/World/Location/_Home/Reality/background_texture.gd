extends SubViewport

@onready var bg_cam: Camera3D = $BgCam
@onready var scene_background: Node3D = $ExtraSkybox/BackgroundTexture/SceneBackground
@onready var world0: Node3D = $"../../../"

func _process(_delta: float) -> void:
	size = get_window().size
	bg_cam.global_rotation = Global.CurrentWorld.player0.first_person_cam.global_rotation
	@warning_ignore("unsafe_property_access")
	world_3d.environment.ambient_light_color = world0.ambient_color
