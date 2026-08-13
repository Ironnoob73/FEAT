extends Camera3D

var mouse_pos : Vector2
@onready var hand_held: HandHeldAnimation = $HandHeldRight
@onready var player: LocalPlayer = get_node("/root/World/Player")

func _input(event: InputEvent) -> void:
	if player.current_menu == "ToolSetting":
		if event is InputEventMouseMotion:
			var mouse_motion_event: InputEventMouseMotion = event
			if mouse_pos != mouse_motion_event.position:
				set_mouse_position()
				mouse_pos = mouse_motion_event.position
		if event is InputEventMouseButton:
			var mouse_button_event: InputEventMouseButton = event
			if mouse_button_event.pressed and mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
				get_selection()
			
func set_mouse_position() -> void:
	var _worldspace: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var end: Vector3 = project_position(mouse_pos, 1)
	@warning_ignore("unsafe_method_access")
	hand_held.get_child(0).move_event(end)
	
func get_selection() -> void:
	var _worldspace: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	#var start = project_ray_origin(mouse_pos)
	var end: Vector3 = project_position(mouse_pos,1)
	#var ray = PhysicsRayQueryParameters3D.create(start,end)
	#ray.collision_mask = 64
	#var result = worldspace.intersect_ray(ray)
	hand_held.get_child(0).click_event(end)
	
