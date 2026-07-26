@tool
class_name ElevatorDoor
extends AHL_Interactive

signal opening_done
signal closing_done

@export var open : bool = false:
	set(state):
		open = state
		if Engine.is_editor_hint():
			open_setter()
			
var is_opening : bool = false:
	set(state):
		is_opening = state
		if !state:
			opening_done.emit()
var is_closing : bool = false:
	set(state):
		is_closing = state
		if !state:
			closing_done.emit()
			
var tween: Tween
			
@onready var door_l: Node3D = $ElevatorDoorL
@onready var door_r: Node3D = $ElevatorDoorR

func _ready() -> void:
	super._ready()
	open_setter()

func switch(value : bool, sender : Node) -> void:
	super.switch(value, sender)
	if open != value:
		if tween:
			tween.kill()
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
		var _p_tween: PropertyTweener = null
		if value :
			_p_tween = tween.tween_property(self, "is_opening", true, 0)
			_p_tween = tween.tween_property(door_l, "position:x", -0.995, 1)
			_p_tween = tween.tween_property(door_r, "position:x", 0.995, 1)
			_p_tween = tween.tween_property(self, "is_opening", false, 0).set_delay(1.5)
			open = value
		elif !is_opening:
			_p_tween = tween.tween_property(self, "is_closing", true, 0)
			_p_tween = tween.tween_property(door_l, "position:x", -0.005, 1)
			_p_tween = tween.tween_property(door_r, "position:x", 0.005, 1)
			_p_tween = tween.tween_property(self, "is_closing", false, 0).set_delay(1.5)
			open = value
	else:
		if value:
			opening_done.emit()
		else:
			closing_done.emit()
	
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
