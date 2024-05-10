extends AnimatableBody3D

var open : bool = false

func interact():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	open = !open
	if open :	tween.tween_property(self, "rotation:y", deg_to_rad(90), 0.5)
	else :		tween.tween_property(self, "rotation:y", 0, 0.5)
