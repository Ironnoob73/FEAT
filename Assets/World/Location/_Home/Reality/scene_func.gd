extends Node

@onready var computer_scene: AHL_Interactive = $"../Inner/ComputerScene"
@onready var start_screen: Sprite2D = $"../StartScreen"
var isStart: bool = false

var player_is_falling: bool = false
var current_pos: Vector3 = Vector3(0,0,0)
var current_vel: float = 0

@onready var color_rect: ColorRect = $"../ExitArea/ColorRect"
@onready var exit_text: VBoxContainer = $"../ExitArea/ColorRect/VBoxContainer"
# Exit icon from: https://www.svgrepo.com/svg/509594/ja301-emergency-exit

func _process(_delta: float) -> void:
	if !isStart and Global.THE_PLAYER != null:
		isStart = true
		Global.THE_PLAYER.set_meta("lock_hud_hidden",true)
		Global.THE_PLAYER.set_meta("lock_menu",true)
		computer_scene.interact(Global.THE_PLAYER)
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(start_screen, "modulate:a", 0, 1).set_delay(1)
		tween.tween_property(start_screen, "visible", false, 0)
		
	if player_is_falling:
		current_vel = lerpf(current_vel, 0.005, 0.05)
		current_pos.y -= current_vel
		Global.THE_PLAYER.position = current_pos

func _on_drop_area_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		player_is_falling = true
		current_pos = body.global_position
		current_vel = abs(body.velocity.y) * 0.01
		
		body.hide_hud(true)
		body.set_meta("lock_hud_hidden",true)

func _on_exit_area_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		body.current_menu = "exit"
		body.hide_hud(true)
		body.set_meta("lock_hud_hidden",true)
		body.set_meta("lock_menu",true)

		var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(color_rect, "visible", true, 0)
		tween.tween_property(color_rect, "color:a", 1, 1).set_delay(0.25)
		tween.tween_property(exit_text, "modulate:a", 1, 2)
		tween.tween_callback(func():get_tree().quit())
