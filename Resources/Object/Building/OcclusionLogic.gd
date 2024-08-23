@tool
extends Node

func occlusion_setter(obj:Node):
	if is_instance_valid(obj.occlusion_obj):
		match obj.occlusion:
			"none" :
				obj.occlusion_obj.hide()
				obj.occlusion_light_obj.hide()
			"dark" :
				obj.occlusion_obj.show()
				obj.occlusion_light_obj.hide()
			"light" :
				obj.occlusion_light_obj.show()
				obj.occlusion_obj.hide()
