extends SubViewport
class_name sub_room_viewport
## For a portal-like visual correction.

@onready var camera_3d: Camera3D = $Camera3D
@export var environment: Environment

var sun_axis: sun_axis_class = null

func _ready() -> void:
	if environment:
		world_3d = World3D.new()
		world_3d.environment = environment
		
	#sun_axis = Global.CurrentWorld.sun_axis.duplicate()
	add_child(sun_axis)

func _process(_delta: float) -> void:
	size = get_window().size
	var player_cam: Camera3D = Global.CurrentWorld.player0.first_person_cam
	camera_3d.global_position = player_cam.global_position
	camera_3d.global_rotation = player_cam.global_rotation
	
	#var global_sun_axis: sun_axis_class = Global.CurrentWorld.sun_axis
	#if sun_axis != null:
	#	sun_axis.global_rotation = global_sun_axis.global_rotation
	#	sun_axis.rotation_y = global_sun_axis.rotation_y
	#	sun_axis.visible = own_world_3d
