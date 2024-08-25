extends AnimatableBody3D

var open : bool = false
var interact_icon : String = "🤚"

func interact(_sender):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	open = !open
	if open :	tween.tween_property(self, "rotation:x", deg_to_rad(60), 0.5)
	else :		tween.tween_property(self, "rotation:x", 0, 0.5)
