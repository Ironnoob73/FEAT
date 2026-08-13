extends Node3D
class_name RoomConnector
## Connect two rooms defined by [SubRoomViewport], most of the time for Area3D.

@export var door_plate: AHL_Interactive
@export var from_viewport: SubRoomViewport
@export var to_room_view: MeshInstance3D
@export var to_room_area: RoomConnector

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
	if sender is not RoomConnector:
		to_room_area.door_plate.interact(self)
	
func _on_door_plate_switch_signal(state: bool, sender: Variant) -> void:
	if sender is not RoomConnector:
		to_room_area.door_plate.switch(state, self)
	
static func change_room(from: SubRoomViewport, to: SubRoomViewport) -> void:
	from.set_use_own_world_3d(true)
	from.world_3d = World3D.new()
	to.set_use_own_world_3d(false)
	to.world_3d = null
	Global.current_world.player0.player_camera.set_current(true)
	from.camera_3d.set_current(true)
