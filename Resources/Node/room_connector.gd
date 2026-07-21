extends Node3D
class_name room_connector
## Connect two rooms defined by [sub_room_viewport], most of the time for Area3D.

#signal to_room(from: SubViewport, to: SubViewport)

@export var door_plate: AHL_Interactive
@export var from_viewport: sub_room_viewport
@export var to_room_view: MeshInstance3D
@export var to_room_area: room_connector

func _ready() -> void:
	var _self_connect: int = connect("body_entered", _on_area_3d_body_entered, 1)
	if door_plate:
		#var _door_connect : int = door_plate.interact_signal.connect(_on_door_plate_interact_signal, 1)
		var _door_state_sync : int = door_plate.state_change_signal.connect(_on_door_plate_switch_signal, 1)
	if to_room_view and to_room_area and to_room_area.from_viewport:
		var R0 : MeshInstance3D = to_room_view
		var r0_mat: ShaderMaterial = R0.material_override
		r0_mat.set_shader_parameter("sky_texture", to_room_area.from_viewport.get_texture())

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		change_room(from_viewport, to_room_area.from_viewport)

func _on_door_plate_interact_signal(_interactor: Variant, sender: Variant) -> void:
	if not sender is room_connector:
		to_room_area.door_plate.interact(self)
	
func _on_door_plate_switch_signal(state: bool, sender: Variant) -> void:
	if not sender is room_connector:
		to_room_area.door_plate.switch(state, self)
	
static func change_room(from: sub_room_viewport, to: sub_room_viewport) -> void:
	from.set_use_own_world_3d(true)
	from.world_3d = World3D.new()
	to.set_use_own_world_3d(false)
	to.world_3d = null
	Global.CurrentWorld.player0.player_camera.set_current(true)
	from.camera_3d.set_current(true)
