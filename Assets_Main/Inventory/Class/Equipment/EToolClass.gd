extends EquipmentClass
class_name EToolClass

@export_enum("undefined","wrench","screwdriver","special","pickaxe","sword") var tool_type : String = "undefined"
@export var scene : PackedScene
@export var hitbox : Vector3 = Vector3(0.25,0.25,1)
@export var the_script : GDScript

func get_subname():
	if name1 :	return name1
	else :	return "tool.type." + tool_type
