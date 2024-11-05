extends StaticBody3D

@onready var _button = $Button

func _interact_signal(_i,_s) -> void:
	if is_node_ready():
		_press()
		
func _press():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(_button, "position:z", 0.03, 0)
	tween.tween_property(_button, "position:z", 0.05, 0.5)
