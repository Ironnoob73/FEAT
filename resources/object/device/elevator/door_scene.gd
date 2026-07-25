@tool
extends AHL_Interactive

@onready var door_l: Node3D = $ElevatorDoorL
@onready var door_r: Node3D = $ElevatorDoorR

@export var open : bool = false:
	set(state):
		open = state
		if Engine.is_editor_hint():
			open_setter()
			
signal opening_done
var is_opening : bool = false:
	set(state):
		is_opening = state
		if !state:
			opening_done.emit()

func _ready() -> void:
	super._ready()
	open_setter()

func switch(value : bool, sender : Node) -> void:
	super.switch(value, sender)
	if open != value :
		var tween: Tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
		var _p_tween: PropertyTweener = null
		if value :
			_p_tween = tween.tween_property(self, "is_opening", true, 0)
			_p_tween = tween.tween_property(door_l, "position:x", -0.995, 1)
			_p_tween = tween.tween_property(door_r, "position:x", 0.995, 1)
			_p_tween = tween.tween_property(self, "is_opening", false, 0).set_delay(1.5)
			open = value
		elif !is_opening:
			_p_tween = tween.tween_property(door_l, "position:x", -0.005, 1)
			_p_tween = tween.tween_property(door_r, "position:x", 0.005, 1)
			open = value
	
func open_setter() -> void:
	if is_instance_valid(door_l):
		if open :
			door_l.position.x = -0.995
			door_r.position.x = 0.995
		else:
			door_l.position.x = -0.005
			door_r.position.x = 0.005
			
func _on_elevator_door_interact_signal(interactor: AHL_Interactive, sender: Node) -> void:
	switch(interactor.state, sender)
