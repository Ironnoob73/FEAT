extends Camera3D

var mouse_pos : Vector2
@onready var hand_held = $HandHeldRight
@onready var Player = get_node("/root/World/Player")

func _input(event):
	if Player.current_menu == "ToolSetting":
		if event is InputEventMouseMotion and mouse_pos != event.position:
			set_mouse_position()
			mouse_pos = event.position
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				get_selection()
			
func set_mouse_position():
	var _worldspace = get_world_3d().direct_space_state
	var end = project_position(mouse_pos,1)
	hand_held.get_child(0).move_event(end)
	
func get_selection():
	var _worldspace = get_world_3d().direct_space_state
	#var start = project_ray_origin(mouse_pos)
	var end = project_position(mouse_pos,1)
	#var ray = PhysicsRayQueryParameters3D.create(start,end)
	#ray.collision_mask = 64
	#var result = worldspace.intersect_ray(ray)
	hand_held.get_child(0).click_event(end)
	
