@tool
extends StaticBody3D

@onready var mesh = $DoorFrame
@export var mesh_color : Color = Color(0,0,0,0):
	set(color):
		mesh_color = color
		if Engine.is_editor_hint():
			color_setter()
@export var mesh_material : Material = preload("res://Resources/Material/Tree.tres"):
	set(material):
		mesh_material = material
		if Engine.is_editor_hint():
			material_setter()
@export_enum("none","dark","light") var occlusion : String = "dark":
	set(state):
		occlusion = state
		OcclusionLogic.occlusion_setter(self)
@export var ToLocation : String = "null"
@export var ToLocationPos : Vector3 = Vector3(0,1,0)
@onready var occlusion_obj: MeshInstance3D = $Occlusion
@onready var occlusion_light_obj: MeshInstance3D = $Occlusion_light

func _ready():
	if mesh_color != Color(0,0,0,0) :	MaterialUtil.recolor(mesh,mesh_color)
	if mesh_material : MaterialUtil.change_material(mesh,mesh_material)
	OcclusionLogic.occlusion_setter(self)
	
func color_setter():
	MaterialUtil.recolor(mesh,mesh_color)
func material_setter():
	MaterialUtil.change_material(mesh,mesh_material)
	
func teleport():
	get_node("/root/World").change_scene(ToLocation,ToLocationPos)
