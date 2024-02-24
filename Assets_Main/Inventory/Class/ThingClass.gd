extends Resource
class_name ThingClass

@export var name0 : String
@export var icon : Texture
@export var model : Mesh
@export var material : Material
@export var discription : String

func get_discription():
	if discription :	return discription
	else :	return name0 + ".discription"
