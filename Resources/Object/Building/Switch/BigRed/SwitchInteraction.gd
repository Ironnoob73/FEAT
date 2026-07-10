extends StaticBody3D

@onready var _button: MeshInstance3D = $Button

func _interact_signal(_i: Node,_s: Node) -> void:
	if is_node_ready():
		_press()
		
func _press() -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	var _p_tween: PropertyTweener = tween.tween_property(_button, "position:z", 0.03, 0)
	_p_tween = tween.tween_property(_button, "position:z", 0.05, 0.5)
