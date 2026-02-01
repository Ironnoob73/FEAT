extends Node3D

signal to_room
signal open_door(sender: Variant)
@onready var door_plate: AHL_Interactive = $FrameScene0/DoorPlate

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		to_room.emit.call_deferred()

func _on_door_plate_interact_signal(_interactor: Variant, sender: Variant) -> void:
	open_door.emit(sender)

func _open_door(sender: Variant) -> void:
	door_plate.interact(sender)
