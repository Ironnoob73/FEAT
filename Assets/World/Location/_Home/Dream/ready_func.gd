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
	
	room_connector.change_room.call_deferred(corridor_scene,room_scene)

func _switch_to_cloud(_interactor: Variant, _sender: Variant) -> void:
	Global.set_meta("wrap_from", "DreamApartment")
	AHL_LoadManager.load_scene("res://Assets/World/Location/16_Cloud/_ScenesPackage.tscn", false, Vector3(0,0,0), false, Vector3(0,0,0), false)
