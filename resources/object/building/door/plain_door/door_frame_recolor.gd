@tool
extends OcclusionedStaticBody

@onready var mesh: MeshInstance3D = $DoorFrame
@onready var bottom_mesh: MeshInstance3D = $Bottom
@export var mesh_color : Color = Color(0,0,0,0):
	set(color):
		mesh_color = color
		if Engine.is_editor_hint():
			color_setter()
@export var mesh_material : Material = preload("res://resources/material/tree.tres"):
	set(material):
		mesh_material = material
		if Engine.is_editor_hint():
			material_setter()
@export var bottom : bool = false :
	set(state):
		bottom = state
		bottom_mesh.visible = state
@export var ToLocation : String = "null"
@export var ToLocationPos : Vector3 = Vector3(0,0,0)

func _ready() -> void:
	if mesh_color != Color(0,0,0,0) :	MaterialUtil.recolor(mesh,mesh_color)
	if mesh_material : MaterialUtil.change_material(mesh,mesh_material)
	OcclusionLogic.occlusion_setter(self)
	
func color_setter() -> void:
	MaterialUtil.recolor(mesh,mesh_color)
func material_setter() -> void:
	MaterialUtil.change_material(mesh,mesh_material)
