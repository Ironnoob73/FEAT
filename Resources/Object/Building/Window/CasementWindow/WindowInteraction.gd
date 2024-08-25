@tool
extends AnimatableBody3D

var interact_icon : String = "🤚"

@export var open : bool = false:
	set(state):
		open = state
		if Engine.is_editor_hint():
			open_setter()

func _ready() -> void:
	if open:	self.rotation.y = deg_to_rad(90)
			
func open_setter():
	if open:	self.rotation.y = deg_to_rad(90)
	else :	self.rotation.y = 0
	
func interact(_sender):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	open = !open
	if open :	tween.tween_property(self, "rotation:y", deg_to_rad(90), 0.5)
	else :		tween.tween_property(self, "rotation:y", 0, 0.5)
