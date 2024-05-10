extends StaticBody3D

@onready var door = $DoorPlate/Mesh
@export var door_color : Color = Color(0,0,0,0)
@export var door_material : Material
@onready var frame = $DoorFrame
@export var frame_color : Color = Color(0,0,0,0)
@export var frame_material : Material

func _ready():
	if door_color != Color(0,0,0,0) :	MaterialUtil.recolor(door,door_color)
	if door_material : MaterialUtil.change_material(door,door_material)
	if frame_color != Color(0,0,0,0) :	MaterialUtil.recolor(frame,frame_color)
	if frame_material : MaterialUtil.change_material(frame,frame_material)
