@tool
extends Node3D
class_name AHL_ScenePackage

@export var chunks : Array[AHL_ChunkPath]
@export var rooms : Array[AHL_RoomInstance]
@export var background : Texture2D
@export var environment : Environment

var room_scenes : Dictionary = {}

func _ready() -> void:
	for i in rooms:
		if i.room_name && i.room_scene:
			room_scenes[i.room_name] = i.room_scene.instantiate()
