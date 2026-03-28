extends Node3D
class_name room_connector

signal to_room(from: SubViewport, to: SubViewport)

@export var door_plate: AHL_Interactive
@export var from_viewport: SubViewport
@export var to_room_view: MeshInstance3D
@export var to_room_area: room_connector

func _ready() -> void:
	var _self_connect: int = connect("body_entered", _on_area_3d_body_entered, 1)
	if door_plate:
		var _door_connect: int = door_plate.interact_signal.connect(_on_door_plate_interact_signal, 1)
	if to_room_view and to_room_area and to_room_area.from_viewport:
		var R0 : MeshInstance3D = to_room_view
		var r0_mat: ShaderMaterial = R0.material_override
		r0_mat.set_shader_parameter("sky_texture", to_room_area.from_viewport.get_texture())

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		to_room.emit.call_deferred(from_viewport, to_room_area.from_viewport)

func _on_door_plate_interact_signal(_interactor: Variant, sender: Variant) -> void:
	if sender is LocalPlayer:
		to_room_area._open_door(self)

func _open_door(sender: Variant) -> void:
	var p_sender: Node = sender
	door_plate.interact(p_sender)
