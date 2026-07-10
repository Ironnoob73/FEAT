extends StaticBody3D

@onready var elevator_door: AHL_Interactive = $"../ElevatorDoor"

func _timeout_unlit(interactor: AHL_Interactive) -> void:
	await get_tree().create_timer(0.5,false,true,false).timeout
	interactor.state = false

func _on_open_interact_signal(interactor: AHL_Interactive, _s: Variant) -> void:
	elevator_door.switch(true)
	await _timeout_unlit(interactor)

func _on_close_interact_signal(interactor: AHL_Interactive, _s: Variant) -> void:
	elevator_door.switch(false)
	await _timeout_unlit(interactor)
