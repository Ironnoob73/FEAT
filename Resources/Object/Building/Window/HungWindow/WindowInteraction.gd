extends AnimatableBody3D

var open : bool = false

func interact(_sender):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	open = !open
	if open :	tween.tween_property(self, "position:y", 0.9, 0.5)
	else :		tween.tween_property(self, "position:y", 0.1, 0.5)
