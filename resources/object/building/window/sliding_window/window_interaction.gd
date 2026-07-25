extends AnimatableBody3D

var open : bool = false

func _ready() -> void:
	if !get_parent().is_node_ready():
		await get_parent().ready
		_state_change()
			
func _interact_signal(_i: Variant, _s: Variant) -> void:
	if is_node_ready():
		_state_change()
		
func _state_change() -> void:
	if get_parent() is AHL_Interactive:
		var parent: AHL_Interactive = get_parent()
		var _p_tween: PropertyTweener = null
		if parent.state:
			parent.interact_text = "interact.close"
			open = true
			var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			if name == "LeftWindow" :
				_p_tween = tween.tween_property(self, "position:x", 1.4, 0.5)
			else :
				_p_tween = tween.tween_property(self, "position:x", -1.4, 0.5)
		else :
			parent.interact_text = "interact.open"
			open = false
			var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			if name == "LeftWindow" :
				_p_tween = tween.tween_property(self, "position:x", 0, 0.5)
			else :
				_p_tween = tween.tween_property(self, "position:x", 0, 0.5)
