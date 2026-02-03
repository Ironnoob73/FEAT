extends Node

@onready var computer_scene: AHL_Interactive = $"../Inner/ComputerScene"
@onready var start_screen: Sprite2D = $"../StartScreen"

var player_is_falling: bool = false
var current_pos: Vector3 = Vector3(0,0,0)
var current_vel: float = 0

@onready var color_rect: ColorRect = $"../ExitArea/ColorRect"
@onready var exit_text: VBoxContainer = $"../ExitArea/ColorRect/VBoxContainer"
# Exit icon from: https://www.svgrepo.com/svg/509594/ja301-emergency-exit

func _process(_delta: float) -> void:
	if !Global.LaunchReady and Global.CurrentWorld.player0 != null:
		Global.LaunchReady = true
		Global.CurrentWorld.player0.set_meta("lock_hud_hidden",true)
		Global.CurrentWorld.player0.set_meta("lock_menu",true)
		start_screen.show()
		computer_scene.interact(Global.CurrentWorld.player0)
		var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		var _p_tween: PropertyTweener = null
		var _c_tween: CallbackTweener = null
		if !Global.FastBoot or Global.oobe:
			_p_tween = tween.tween_property(start_screen, "modulate:a", 0, 1).set_delay(1)
			_p_tween = tween.tween_property(start_screen, "visible", false, 0)
		else:
			_p_tween = tween.tween_property(start_screen, "modulate:a", 0, 0.1).set_delay(1)
			_p_tween = tween.tween_property(start_screen, "visible", false, 0)
			_c_tween = tween.tween_callback(func()->void:Global.CurrentWorld.player0.remove_meta("lock_hud_hidden"))
			_c_tween = tween.tween_callback(func()->void:Global.CurrentWorld.player0.remove_meta("lock_menu"))
		
	if player_is_falling:
		current_vel = lerpf(current_vel, 0.005, 0.05)
		current_pos.y -= current_vel
		Global.CurrentWorld.player0.position = current_pos

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
