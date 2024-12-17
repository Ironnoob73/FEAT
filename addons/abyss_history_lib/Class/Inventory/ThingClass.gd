extends Resource
class_name ThingClass

@export var name0 : String
@export var icon : Texture = preload("res://Resources/Image/missing.svg")
@export var model : Mesh = preload("res://Resources/Object/Function/Pickable/missing.obj")
@export var material : Material = preload("res://Resources/Object/Function/Pickable/DefaultMaterial.tres")
@export var description : String = "item.no_des"

@export var pos_offset : Vector3 = Vector3(0,0,0)
@export var pos_rotation : Vector3 = Vector3(0,0,0)
@export var pos_scale : Vector3 = Vector3(1,1,1)

func get_description() -> String:
	if description :	return description
	else :	return name0 + ".description"

func pos_rotation_rad() -> Vector3:
	return Vector3(deg_to_rad(pos_rotation.x),deg_to_rad(pos_rotation.y),deg_to_rad(pos_rotation.z))
