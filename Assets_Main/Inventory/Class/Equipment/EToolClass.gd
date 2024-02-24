extends EquipmentClass
class_name EToolClass

@export_enum("undefined","wrench","screwdriver","special","pickaxe") var tool_type : String = "undefined"
@export var scene : PackedScene
@export_enum("none","blocky","smooth","dynamic") var affect_terrain : String = "none"

func get_subname():
	if name1 :	return name1
	else :	return "tool.type." + tool_type
