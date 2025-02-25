@tool
class_name MaterialUtil

static func recolor(obj,color):
	if obj != null && obj.get_material_overlay() :
		var mat_d = obj.material_overlay.duplicate()
		obj.material_overlay = mat_d
		obj.material_overlay.set_shader_parameter("color",color)
	
static func change_material(obj,material):
	if obj != null:
		var mat_d = obj.material_override.duplicate()
		obj.material_override = mat_d
		obj.material_override = material
