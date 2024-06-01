extends Resource
class_name ThingClass

@export var name0 : String
@export var icon : Texture = preload("res://Resources/Image/missing.svg")
@export var model : Mesh = preload("res://Resources/Object/Function/Pickable/missing.obj")
@export var material : Material = preload("res://Resources/Object/Function/Pickable/DefaultMaterial.tres")
@export var description : String = "item.no_des"

func get_description():
	if description :	return description
	else :	return name0 + ".description"
