extends Node

@onready var roof_scene: sub_room_viewport = $"../RoofScene"
@onready var elevator_scene: sub_room_viewport = $"../ElevatorScene"

@onready var elevator_door: AHL_Interactive = $"../ElevatorScene/TheElevator/ElevatorDoor"

func _ready() -> void:
	if Global.has_meta("wrap_from"):
		var from: String = Global.get_meta("wrap_from")
		if from == "DreamApartment":
			room_connector.change_room.call_deferred(roof_scene,elevator_scene)
			elevator_door.interact(self)
		Global.remove_meta("wrap_from")
