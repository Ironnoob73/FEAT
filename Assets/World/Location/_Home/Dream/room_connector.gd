extends Node3D
class_name sub_room

signal to_room
signal open_door(sender: Variant)

@export var door_plate: AHL_Interactive
@export var to_room_scene: SubViewport
@export var to_room_view: MeshInstance3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		to_room.emit.call_deferred(self.get_parent(), to_room_scene)

func _on_door_plate_interact_signal(_interactor: Variant, sender: Variant) -> void:
	if sender is LocalPlayer:
		open_door.emit(self)

func _open_door(sender: Variant) -> void:
	var p_sender: Node = sender
	door_plate.interact(p_sender)
