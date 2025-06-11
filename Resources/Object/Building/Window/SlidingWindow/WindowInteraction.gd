extends AnimatableBody3D

var open : bool = false

func _ready() -> void:
	if !get_parent().is_node_ready():
		await get_parent().ready
		_state_change()
			
func _interact_signal(_i: Variant, _s: Variant) -> void:
	if is_node_ready():
		_state_change()
		
func _state_change():
	if get_parent() is AHL_Interactive:
		if get_parent().state:
			get_parent().interact_text = "interact.close"
			open = true
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			if name == "LeftWindow" :
				tween.tween_property(self, "position:x", 1.4, 0.5)
			else :
				tween.tween_property(self, "position:x", -1.4, 0.5)
		else :
			get_parent().interact_text = "interact.open"
			open = false
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			if name == "LeftWindow" :
				tween.tween_property(self, "position:x", 0, 0.5)
			else :
				tween.tween_property(self, "position:x", 0, 0.5)
