@tool
extends Node3D

@export var chunks : Array[AHL_ChunkPath]
@export var rooms : Array[AHL_RoomInstance]
@export var background : Texture2D

var room_scenes : Dictionary = {}

func _ready() -> void:
	for i in rooms:
		if i.room_name && i.room_scene:
			room_scenes[i.room_name] = i.room_scene.instantiate()
