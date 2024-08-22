@tool
extends Node

func occlusion_setter(obj:Node):
	if is_instance_valid(obj.occlusion_obj):
		match obj.occlusion:
			"none" :
				obj.occlusion_obj.visible = false
				obj.occlusion_light_obj.visible = false
			"dark" :
				obj.occlusion_obj.visible = true
				obj.occlusion_light_obj.visible = false
			"light" :
				obj.occlusion_light_obj.visible = true
				obj.occlusion_obj.visible = false
