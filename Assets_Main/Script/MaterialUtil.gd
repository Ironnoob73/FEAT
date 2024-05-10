extends Node

func recolor(obj,color):
	var mat_d = obj.material_overlay.duplicate()
	obj.material_overlay = mat_d
	obj.material_overlay.set_shader_parameter("color",color)
	
func change_material(obj,material):
	var mat_d = obj.material_override.duplicate()
	obj.material_override = mat_d
	obj.material_override = material
