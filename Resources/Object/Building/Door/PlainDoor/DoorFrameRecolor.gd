@tool
extends StaticBody3D

@onready var mesh = $DoorFrame
@export var mesh_color : Color = Color(0,0,0,0)
@export var mesh_material : Material

func _ready():
	if mesh_color != Color(0,0,0,0) :	MaterialUtil.recolor(mesh,mesh_color)
	if mesh_material : MaterialUtil.change_material(mesh,mesh_material)
