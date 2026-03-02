extends Node3D

signal to_room
signal open_door(sender: Variant)
@onready var door_plate: AHL_Interactive = $FrameScene0/DoorPlate

@onready var down_stair_view: MeshInstance3D = $ElevatorCorridorSolid/DownStairView
@onready var down_stair_viewport: SubViewport = $ElevatorCorridorSolid/DownStairView/SubViewport
@onready var down_stair_camera: Camera3D = $ElevatorCorridorSolid/DownStairView/SubViewport/Camera3D
@onready var up_stair_view: MeshInstance3D = $ElevatorCorridorSolid/UpStairView
@onready var up_stair_viewport: SubViewport = $ElevatorCorridorSolid/UpStairView/SubViewport
@onready var up_stair_camera: Camera3D = $ElevatorCorridorSolid/UpStairView/SubViewport/Camera3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		to_room.emit.call_deferred()

func _on_door_plate_interact_signal(_interactor: Variant, sender: Variant) -> void:
	if get_parent() is not SubViewport:
		open_door.emit(sender)

func _open_door(sender: Variant) -> void:
	var p_sender: Node = sender
	door_plate.interact(p_sender)

func _process(_delta: float) -> void:
	if down_stair_camera and down_stair_view and down_stair_viewport:
		down_stair_viewport.size = get_window().size
		var r0_mat: ShaderMaterial = down_stair_view.material_override
		if get_parent() is not SubViewport:
			r0_mat.set_shader_parameter("sky_texture", down_stair_viewport.get_texture())
			var player_cam: Camera3D = Global.CurrentWorld.player0.first_person_cam
			down_stair_camera.position = player_cam.global_position + Vector3(0,8,0)
			down_stair_camera.rotation = player_cam.global_rotation
		else:
			r0_mat.set_shader_parameter("sky_texture", null)
	if up_stair_camera and up_stair_view and up_stair_viewport:
		up_stair_viewport.size = get_window().size
		var r0_mat: ShaderMaterial = up_stair_view.material_override
		if get_parent() is not SubViewport:
			r0_mat.set_shader_parameter("sky_texture", up_stair_viewport.get_texture())
			var player_cam: Camera3D = Global.CurrentWorld.player0.first_person_cam
			up_stair_camera.position = player_cam.global_position + Vector3(0,-8,0)
			up_stair_camera.rotation = player_cam.global_rotation
		else:
			r0_mat.set_shader_parameter("sky_texture", null)

func _physics_process(_delta: float) -> void:
	if Global.CurrentWorld.player0.global_position.y > 3:
		Global.CurrentWorld.player0.global_position.y -= 4
	if Global.CurrentWorld.player0.global_position.y < -1:
		Global.CurrentWorld.player0.global_position.y += 4
