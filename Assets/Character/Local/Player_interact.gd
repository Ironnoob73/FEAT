extends RayCast3D

var hit_point : Vector3

@onready var _cursor = $"../../Cursor"
@onready var _detection_area : Area3D = $"../../Cursor/DetectionArea"
@onready var tooltip = $"../../CrossHair/InteractionTip"
@onready var tooltip_icon = $"../../CrossHair/InteractionTip/Icon"
@onready var tooltip_text = $"../../CrossHair/InteractionTip/Text"

@onready var inventory = preload("res://Assets/Inventory/Player_inventory.tres")
@onready var HandHeldItem = $"../FirstPersonHandled/SubViewport/FirstPersonCam/HandHeldRight"
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
		if Global.alwaysShowCursor: _cursor.show()
		_cursor.set_global_position(Vector3(hit_point)+Vector3(0.5,0.25,0.5))
	# Interact
	if is_colliding() and get_collider().get_parent() is AHL_Interactive:
		tooltip_icon.text = get_collider().get_parent().interact_icon
		if get_collider().get_parent().Interactable == true:
			var key_array : Array = []
			for i in InputMap.action_get_events("interact"):
				key_array.append(i.as_text().rsplit(" ", true, 1)[0])
			tooltip_text.text = str(key_array).replacen("\"","") + tr(get_collider().get_parent().interact_text)
		else: tooltip_text.text = tr(get_collider().get_parent().interact_text)
		if Input.is_action_just_pressed("interact") && Player.current_menu == "HUD":
			get_collider().get_parent().interact(Player)
		tooltip.visible = true
	else:	tooltip.visible = false
		
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

func _input(_event):
	if Player.current_menu == "HUD":
		if HandHeldItem.get_child_count():
			if Input.is_action_just_pressed("main_attack"):
				Player.main_attack(true)
			if Input.is_action_just_pressed("secondary_attack"):
				Player.secondary_attack(true)
			if Input.is_action_just_released("secondary_attack"):
				Player.secondary_attack(false)
		else:
			if Input.is_action_just_pressed("main_attack"):
				Player.main_attack(true)
