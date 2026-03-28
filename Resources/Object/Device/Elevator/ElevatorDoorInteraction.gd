@tool
extends Node

@onready var door_l: Node3D = $"../ElevatorDoorL"
@onready var door_r: Node3D = $"../ElevatorDoorR"

@export var open : bool = false:
	set(state):
		open = state
		if Engine.is_editor_hint():
			open_setter()

func _ready() -> void:
	open_setter()

func switch(value : bool) -> void:
	if open != value :
		var tween: Tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
		var _p_tween: PropertyTweener = null
		open = value
		if open :
			_p_tween = tween.tween_property(door_l, "position:x", -0.995, 1)
			_p_tween = tween.tween_property(door_r, "position:x", 0.995, 1)
		else :
			_p_tween = tween.tween_property(door_l, "position:x", -0.005, 1)
			_p_tween = tween.tween_property(door_r, "position:x", 0.005, 1)
	
func open_setter() -> void:
	if is_instance_valid(door_l):
		if open :
			door_l.position.x = -0.995
			door_r.position.x = 0.995
		else:
			door_l.position.x = -0.005
			door_r.position.x = 0.005
			
func _on_elevator_door_interact_signal(interactor: AHL_Interactive, _s: Variant) -> void:
	switch(interactor.state)
