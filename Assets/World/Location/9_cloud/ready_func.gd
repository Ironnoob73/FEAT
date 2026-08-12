@tool
extends AHL_ScenePackage

@onready var roof_scene: SubRoomViewport = $RoofScene
@onready var elevator_scene: SubRoomViewport = $ElevatorScene

@onready var elevator_door: AHL_Interactive = $ElevatorScene/TheElevator/ElevatorDoor

@onready var the_elevator: Elevator = $ElevatorScene/TheElevator

func _ready() -> void:
	if Global.has_meta("wrap_from"):
		var from: String = Global.get_meta("wrap_from")
		if from == "DreamApartment":
			room_connector.change_room.call_deferred(roof_scene,elevator_scene)
			elevator_door.interact(self)
		Global.remove_meta("wrap_from")
	if Global.has_meta("elevator_music_process"):
		var play_pos: float = Global.get_meta("elevator_music_process")
		the_elevator.music.play(play_pos)
