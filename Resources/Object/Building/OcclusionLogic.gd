@tool
extends StaticBody3D

@export_enum("none","dark","light") var occlusion : String = "dark":
	set(state):
		occlusion = state
		occlusion_setter()
@onready var occlusion_obj: MeshInstance3D = $Occlusion
@onready var occlusion_light_obj: MeshInstance3D = $Occlusion_light

func _ready() -> void:
	occlusion_setter()

func occlusion_setter():
	if is_instance_valid(occlusion_obj) && is_instance_valid(occlusion_light_obj) :
		match occlusion:
			"none" :
				occlusion_obj.visible = false
				occlusion_light_obj.visible = false
			"dark" :
				occlusion_obj.visible = true
				occlusion_light_obj.visible = false
			"light" :
				occlusion_light_obj.visible = true
				occlusion_obj.visible = false
