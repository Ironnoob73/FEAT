extends RayCast3D

var hit_point : Vector3

@onready var _cursor = $"../../Cursor"
@onready var _detection_area : Area3D = $"../../Cursor/DetectionArea"

@onready var inventory = preload("res://Assets_Main/Inventory/Player_inventory.tres")
@onready var HandHeldItem = $"../FirstPersonHandled/SubViewport/FirstPersonCam/HandHeld".get_child(0)
@onready var Player = get_node("/root/World/Player")
	
func _physics_process(_delta):
	# Get hit point & Change cursor color
	if is_colliding() :
		_cursor.material.get_shader_parameter("albedo").set_fill(2)
		hit_point.x = floor(get_collision_point().x)
		hit_point.y = floor(get_collision_point().y) + 0.5 * int(get_collision_point().y - floor(get_collision_point().y) >= 0.49)
		hit_point.z = floor(get_collision_point().z)
		if _detection_area.has_overlapping_bodies() or _detection_area.has_overlapping_areas():
			_cursor.material.set_shader_parameter("color",Vector3(1,0,0))
		else:
			_cursor.material.set_shader_parameter("color",Vector3(0,1,0))
		
	# Move cursor
	if !is_colliding() :	_cursor.hide()
	elif _cursor.visible == true:
		_cursor.set_global_position(lerp(_cursor.global_position,Vector3(hit_point)+Vector3(0.5,0.25,0.5),0.5))
	else:
		_cursor.show()
		_cursor.set_global_position(Vector3(hit_point)+Vector3(0.5,0.25,0.5))
	# Interact
	if is_colliding() and get_collider().is_in_group("Interactive"):
		#$PlayerCam/Hud/Tip.visible = true
		if Input.is_action_just_pressed("interact"):
			get_collider().interact()
	#else:	$PlayerCam/Hud/Tip.visible = false
		
func can_place_voxel_at(pos: Vector3i):
	var space_state = get_viewport().get_world_3d().get_direct_space_state()
	var params = PhysicsShapeQueryParameters3D.new()
	params.collision_mask = 10
	params.transform = Transform3D(Basis(), Vector3(pos) + Vector3(0.5,0.25,0.5))
	var shape = BoxShape3D.new()
	shape.extents = Vector3(0.39, 0.1, 0.39)
	params.set_shape(shape)
	var hits = space_state.intersect_shape(params)
	return hits.size() == 0
