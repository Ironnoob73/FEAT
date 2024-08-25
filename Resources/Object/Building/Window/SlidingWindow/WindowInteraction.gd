extends AnimatableBody3D

var open : bool = false
var interact_icon : String = "🤚"

func interact(_sender):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	open = !open
	if name == "LeftWindow" :
		if open :	tween.tween_property(self, "position:x", 1.4, 0.5)
		else :		tween.tween_property(self, "position:x", 0, 0.5)
	else :
		if open :	tween.tween_property(self, "position:x", -1.4, 0.5)
		else :		tween.tween_property(self, "position:x", 0, 0.5)
