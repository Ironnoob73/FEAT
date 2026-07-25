extends RayCast3D

var hit_point : Vector3

@onready var _cursor: CSGMesh3D = $"../../Cursor"
@onready var _detection_area : Area3D = $"../../Cursor/DetectionArea"
@onready var tooltip: Control = $"../../CrossHair/InteractionTip"
@onready var tooltip_icon: Label = $"../../CrossHair/InteractionTip/Icon"
@onready var tooltip_text: Label = $"../../CrossHair/InteractionTip/Text"

@onready var inventory: CInventoryClass = preload("res://assets/inventory/player_inventory.tres")
@onready var HandHeldItem: HandHeldAnimation = $"../FirstPersonHandled/SubViewport/FirstPersonCam/HandHeldRight"
@onready var player: LocalPlayer = get_node("/root/World/Player")
	
func _physics_process(_delta: float) -> void:
	# Get hit point & Change cursor color
	if is_colliding():
		var shader_m: ShaderMaterial = _cursor.material
		var albedo_color: GradientTexture2D = shader_m.get_shader_parameter("albedo")
		albedo_color.set_fill(GradientTexture2D.FILL_SQUARE)
		hit_point.x = floor(get_collision_point().x)
		var _bool: bool = get_collision_point().y - floor(get_collision_point().y) >= 0.49
		hit_point.y = floor(get_collision_point().y) + 0.5 * int(_bool)
		hit_point.z = floor(get_collision_point().z)
		if _detection_area.has_overlapping_bodies() or _detection_area.has_overlapping_areas():
			shader_m.set_shader_parameter("color",Vector3(1,0,0))
		else:
			shader_m.set_shader_parameter("color",Vector3(0,1,0))
		
	# Move cursor
	if !is_colliding() :
		_cursor.hide()
	elif _cursor.visible == true:
		var lerp_result: Vector3 = lerp(_cursor.global_position, Vector3(hit_point)+Vector3(0.5,0.25,0.5),0.5)
		_cursor.set_global_position(lerp_result)
	else:
		if Global.always_show_cursor: _cursor.show()
		_cursor.set_global_position(Vector3(hit_point)+Vector3(0.5,0.25,0.5))
		
	# Interact
	if player.current_menu == "HUD" and is_colliding():
		var collider: Node = get_collider()
		if collider.get_parent() is AHL_Interactive:
			var interactor: AHL_Interactive = collider.get_parent()
			tooltip_icon.text = interactor.interact_icon
			var isInteractable: bool = interactor.Interactable
			if isInteractable:
				var key_array : Array = []
				for i: InputEvent in InputMap.action_get_events("interact"):
					key_array.append(i.as_text().rsplit(" ", true, 1)[0])
				tooltip_text.text = str(key_array).replacen("\"","") + tr(interactor.interact_text)
			else:
				tooltip_text.text = tr(interactor.interact_text)
			if Input.is_action_just_pressed("interact") and isInteractable:
				interactor.interact(player)
			if !interactor.Hidden:
				tooltip.visible = true
		else:
			tooltip.visible = false
	else:
		tooltip.visible = false
		
func can_place_voxel_at(pos: Vector3i) -> bool:
	var space_state: PhysicsDirectSpaceState3D = get_viewport().get_world_3d().get_direct_space_state()
	var params: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	params.collision_mask = 10
	params.transform = Transform3D(Basis(), Vector3(pos) + Vector3(0.5,0.25,0.5))
	var shape: BoxShape3D = BoxShape3D.new()
	shape.extents = Vector3(0.39, 0.1, 0.39)
	params.set_shape(shape)
	var hits: Array = space_state.intersect_shape(params)
	return hits.size() == 0

func _input(_event: InputEvent) -> void:
	if player.current_menu == "HUD":
		if HandHeldItem.get_child_count():
			if Input.is_action_just_pressed("main_attack"):
				player.main_attack(true)
			if Input.is_action_just_pressed("secondary_attack"):
				player.secondary_attack(true)
			if Input.is_action_just_released("secondary_attack"):
				player.secondary_attack(false)
		else:
			if Input.is_action_just_pressed("main_attack"):
				player.main_attack(true)
