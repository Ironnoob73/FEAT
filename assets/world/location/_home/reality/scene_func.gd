@tool
class_name RealityRoomFunc
extends AHL_ScenePackage

@onready var computer_scene: AHL_Interactive = $Inner/ComputerScene
@onready var start_screen: Sprite2D = $StartScreen

var player_is_falling: bool = false
var current_pos: Vector3 = Vector3(0,0,0)
var current_vel: float = 0

@onready var color_rect: ColorRect = $ExitArea/ColorRect
@onready var exit_text: VBoxContainer = $ExitArea/ColorRect/VBoxContainer
# Exit icon from: https://www.svgrepo.com/svg/509594/ja301-emergency-exit

## Move from WorldMain Scene
@onready var env: WorldEnvironment = $WorldEnvironment
@onready var sun_axis: sun_axis_class = $WorldEnvironment/SunAxis

var ambient_color: Color = Color(0,0,0)

var day_top_color: Color = Color("61738c")
var day_bottom_color: Color = Color("a3a6ab")
var sunset_top_color: Color = Color("bd7d1a")
var sunset_bottom_color: Color = Color("ff9e8c")
var night_top_color: Color = Color("001c2b")
var night_bottom_color: Color = Color("030508")

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if !Global.launch_ready and Global.current_world.player0 != null:
		Global.launch_ready = true
		Global.current_world.player0.set_meta("lock_hud_hidden",true)
		Global.current_world.player0.set_meta("lock_menu",true)
		start_screen.show()
		computer_scene.interact(Global.current_world.player0)
		var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		var _p_tween: PropertyTweener = null
		var _c_tween: CallbackTweener = null
		if !Global.fast_boot or Global.oobe:
			_p_tween = tween.tween_property(start_screen, "modulate:a", 0, 1).set_delay(1)
			_p_tween = tween.tween_property(start_screen, "visible", false, 0)
		else:
			_p_tween = tween.tween_property(start_screen, "modulate:a", 0, 0.1).set_delay(1)
			_p_tween = tween.tween_property(start_screen, "visible", false, 0)
			_c_tween = tween.tween_callback(func() -> void: Global.current_world.player0.remove_meta("lock_hud_hidden"))
			_c_tween = tween.tween_callback(func() -> void: Global.current_world.player0.remove_meta("lock_menu"))
		
	if player_is_falling:
		current_vel = lerpf(current_vel, 0.005, 0.05)
		current_pos.y -= current_vel
		Global.current_world.player0.position = current_pos

	var sunlight: float = Global.current_world.day_percent * PI
	# Sun
	sun_axis.rotation.z = deg_to_rad(Global.current_world.day_percent * 360.0)
	sun_axis.rotation_y = deg_to_rad(80 - sin(sunlight * 2) * 30)
	if sin(sunlight * 2) >= 0 :
		sun_axis.sun_light.visible = true
		sun_axis.sun_light.light_energy = sin(sunlight * 2) * 2
		sun_axis.sun_light.light_color.g = sin(sunlight + PI / 2) * 0.5 + 0.5
		sun_axis.sun_light.light_color.b = sin(sunlight + PI / 2) * 0.8 + 0.15
		sun_axis.sun_visual.light_color = sun_axis.sun_light.light_color
		sun_axis.sun_light.shadow_blur = sin(sunlight) * 5
		sun_axis.sun_visual.light_angular_distance = sin(sunlight) * 5
	elif Global.current_world.day_percent == 0.75 :
		sun_axis.sun_visual.light_energy = 1
		sun_axis.sun_visual.light_color.g = sin(PI / 2) * 0.5 + 0.5
		sun_axis.sun_visual.light_color.b = sin(PI / 2) * 0.8 + 0.15
		sun_axis.sun_visual.light_angular_distance = 0
	else :
		sun_axis.sun_light.visible = false
	# Ambient Color
	var day_offset: float = 0
	if Global.current_world.day_percent >= 0.25:
		day_offset = Global.current_world.day_percent - 0.25
	else:
		day_offset = Global.current_world.day_percent + 0.75
	if day_offset <= 0.25:
		ambient_color.r = 0.63 + (0.37 * day_offset * 4)
		ambient_color.g = 0.64 - (0.02 * day_offset * 4)
		ambient_color.b = 0.67 - (0.12 * day_offset * 4)
	elif day_offset > 0.25 and day_offset <= 0.3:
		ambient_color.r = 1 - (1 * (day_offset - 0.25) * 20)
		ambient_color.g = 0.62 - (0.52 * (day_offset - 0.25) * 20)
		ambient_color.b = 0.55 - (0.38 * (day_offset - 0.25) * 20)
	elif day_offset > 0.3 and day_offset <= 0.75:
		ambient_color = Color(0,0.1,0.17)
	elif day_offset > 0.75:
		ambient_color.r = 0.63 * (day_offset - 0.75) * 4
		ambient_color.g = 0.1 + (0.54 * (day_offset - 0.75) * 4)
		ambient_color.b = 0.17 + (0.5 * (day_offset - 0.75) * 4)
	
	"""
	if Global.CurrentWorld.real_time:
		var current_env: Environment = env.get_environment()
		var current_sky: Sky = current_env.get_sky()
		if current_sky.get_material() is ProceduralSkyMaterial:
			var current_sky_material: ProceduralSkyMaterial = current_sky.get_material()
			current_sky_material.ground_horizon_color = current_sky_material.sky_horizon_color
			current_sky_material.ground_bottom_color = ambient_color
			if day_offset <= 0.25:
				current_sky_material.sky_top_color = day_top_color + ((sunset_top_color - day_top_color) * (day_offset / 0.25))
				current_sky_material.sky_horizon_color = day_bottom_color + ((sunset_bottom_color - day_bottom_color) * (day_offset / 0.25))
			elif day_offset > 0.25 and day_offset <= 0.3:
				current_sky_material.sky_top_color = sunset_top_color + ((night_top_color - sunset_top_color) * ((day_offset - 0.25) / 0.05))
				current_sky_material.sky_horizon_color = sunset_bottom_color + ((night_bottom_color - sunset_bottom_color) * ((day_offset - 0.25) / 0.05))
			elif day_offset > 0.3 and day_offset <= 0.75:
				current_sky_material.sky_top_color = night_top_color
				current_sky_material.sky_horizon_color = night_bottom_color
			elif day_offset > 0.75:
				current_sky_material.sky_top_color = night_top_color + ((day_top_color - night_top_color) * ((day_offset - 0.75) / 0.25))
				current_sky_material.sky_horizon_color = night_bottom_color + ((day_bottom_color - night_bottom_color) * ((day_offset - 0.75) / 0.25))
	"""
			
func _on_drop_area_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		var local_player: LocalPlayer = body
		player_is_falling = true
		current_pos = local_player.global_position
		current_vel = abs(local_player.velocity.y) * 0.01
		
		local_player.hide_hud(true)
		local_player.set_meta("lock_hud_hidden",true)

func _on_exit_area_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		var local_player: LocalPlayer = body
		local_player.current_menu = "exit"
		local_player.hide_hud(true)
		local_player.set_meta("lock_hud_hidden",true)
		local_player.set_meta("lock_menu",true)

		var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		var _p_tween: PropertyTweener = null
		var _c_tween: CallbackTweener = null
		_p_tween = tween.tween_property(color_rect, "visible", true, 0)
		_p_tween = tween.tween_property(color_rect, "color:a", 1, 1).set_delay(0.25)
		_p_tween = tween.tween_property(exit_text, "modulate:a", 1, 2)
		_c_tween = tween.tween_callback(func()->void:get_tree().quit())
