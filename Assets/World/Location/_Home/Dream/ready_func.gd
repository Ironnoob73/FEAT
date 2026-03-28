extends Node

@onready var main_scene: AHL_ScenePackage = $".."
@onready var corridor_scene: SubViewport = $"../CorridorScene"
@onready var room_scene: SubViewport = $"../RoomScene"

var mid_env: Environment = null

func _ready() -> void:
	Global.CurrentWorld.real_time = false
	Global.CurrentWorld.player0.hide_hud(false)
	var esc_tween: Tween = create_tween()
	var _p_tween: PropertyTweener = esc_tween.tween_property(Global.CurrentWorld.player0.transition, "color:a", 0, 0.1)
	Global.CurrentWorld.player0.rotation.x = 0
	Global.CurrentWorld.player0.current_menu = "HUD"
	
	change_room.call_deferred(corridor_scene,room_scene)
	
func change_room(from: sub_room_viewport, to: sub_room_viewport) -> void:
	from.set_use_own_world_3d(true)
	from.world_3d = World3D.new()
	from.world_3d.environment = from.environment
	to.set_use_own_world_3d(false)
	if to.world_3d and to.world_3d.environment:
		Global.CurrentWorld.env.environment = to.world_3d.environment.duplicate(true)
	else:
		Global.CurrentWorld.env.environment = null
	to.world_3d = null
	Global.CurrentWorld.player0.player_camera.set_current(true)
	from.camera_3d.set_current(true)
