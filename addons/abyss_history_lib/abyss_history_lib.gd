@tool
extends EditorPlugin

func _enter_tree() -> void:
	# Scene Package
	add_custom_type("ScenesPackage","Node3D",preload("Class/World/ScenesPackageClass.gd"),preload("Class/World/ScenesPackageIcon.svg"))
	add_custom_type("ChunkPath","Resource",preload("Class/World/ChunkClass.gd"),preload("Class/World/ChunkPathIcon.svg"))
	add_custom_type("RoomInstance","Resource",preload("Class/World/RoomClass.gd"),preload("Class/World/RoomInstanceIcon.svg"))
	# Interact
	#	Attack
	add_custom_type("Hurtable","Node3D",preload("Class/Interact/Attack/HurtableClass.gd"),preload("Class/Interact/Attack/HurtableIcon.svg"))

func _exit_tree() -> void:
	remove_custom_type("ScenesPackage")
	remove_custom_type("ChunkPath")
	remove_custom_type("RoomInstance")
	
	remove_custom_type("Hurtable")
