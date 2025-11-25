extends Node

func _ready() -> void:
	get_parent().get_parent().real_time = false
	var player_i: LocalPlayer = get_parent().get_parent().get_node("Player")
	player_i.hide_hud(false)
	var esc_tween = create_tween()
	esc_tween.tween_property(player_i.transition, "color:a", 0, 0.1)
	player_i.rotation.x = 0
	player_i.current_menu = "HUD"
