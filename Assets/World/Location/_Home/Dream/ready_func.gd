extends Node

@onready var main_scene: AHL_ScenePackage = $".."
@onready var sub_scene: SubViewport = $"../SubScene"

@onready var the_corridor: Node3D = $"../TheCorridor"
@onready var room_0: Node3D = $"../SubScene/Room0"

var mid_env: Environment = null
@onready var camera_3d: Camera3D = $"../SubScene/Camera3D"

func _ready() -> void:
	Global.CurrentWorld.real_time = false
	#var player_i: LocalPlayer = get_parent().get_parent().get_node("Player")
	Global.CurrentWorld.player0.hide_hud(false)
	var esc_tween: Tween = create_tween()
	var _p_tween: PropertyTweener = esc_tween.tween_property(Global.CurrentWorld.player0.transition, "color:a", 0, 0.1)
	Global.CurrentWorld.player0.rotation.x = 0
	Global.CurrentWorld.player0.current_menu = "HUD"
	
	change_room.call_deferred()
	
func change_room() -> void:
	room_0.reparent(main_scene)
	the_corridor.reparent(sub_scene)
	var R0 : MeshInstance3D = room_0.get_node("CorridorView")
	var r0_mat: ShaderMaterial = R0.material_override
	r0_mat.set_shader_parameter("sky_texture", sub_scene.get_texture())
	
	mid_env = Global.CurrentWorld.env.environment.duplicate(true)
	Global.CurrentWorld.env.environment = sub_scene.world_3d.environment.duplicate(true)
	sub_scene.world_3d.environment = mid_env
	
	Global.CurrentWorld.player0.player_camera.set_current(true)

func exit_room_to_corridor() -> void:
	the_corridor.reparent(main_scene)
	room_0.reparent(sub_scene)
	var C0 : MeshInstance3D = the_corridor.get_node("RoomView")
	var c0_mat: ShaderMaterial = C0.material_override
	c0_mat.set_shader_parameter("sky_texture", sub_scene.get_texture())
	
	mid_env = Global.CurrentWorld.env.environment.duplicate(true)
	Global.CurrentWorld.env.environment = main_scene.environment
	sub_scene.world_3d.environment = mid_env
	
	camera_3d.set_current(true)
