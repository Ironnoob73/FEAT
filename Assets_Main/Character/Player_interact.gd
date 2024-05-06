extends RayCast3D

var hit_point : Vector3

@onready var _cursor = $"../../Cursor"

@onready var inventory = preload("res://Assets_Main/Inventory/Player_inventory.tres")
@onready var HandHeldItem = $"../FirstPersonHandled/SubViewport/FirstPersonCam/HandHeld".get_child(0)
@onready var Player = get_node("/root/World/Player")
	
func _physics_process(_delta):
	#Get hit point & Change cursor color
	if is_colliding() :
			_cursor.material.get_shader_parameter("albedo").set_fill(2)
			hit_point.x = floor(get_collision_point().x)
			hit_point.y = get_collision_point().y
			hit_point.z = floor(get_collision_point().z)
			_cursor.material.set_shader_parameter("color",Vector3(1,0,0))
		
	#Move cursor
	if !is_colliding() :	_cursor.hide()
	elif _cursor.visible == true:
		_cursor.set_global_position(lerp(_cursor.global_position,Vector3(hit_point)+Vector3(0.5,0.5,0.5),0.5))
	else:
		_cursor.show()
		_cursor.set_global_position(Vector3(hit_point)+Vector3(0.5,0.5,0.5))
