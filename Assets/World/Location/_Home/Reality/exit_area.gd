extends Area3D

@onready var color_rect: ColorRect = $ColorRect

func _on_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		body.current_menu = "exit"
		body.hide_hud(true)
		body.set_meta("lock_hud_hidden",true)
		body.set_meta("lock_menu",true)

		var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(color_rect, "visible", true, 0)
		tween.tween_property(color_rect, "color:a", 1, 3).set_delay(0.25)
