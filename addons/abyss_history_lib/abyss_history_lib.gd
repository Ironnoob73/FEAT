@tool
extends EditorPlugin

func _enter_tree() -> void:
	#Scene Package
	add_custom_type("ScenesPackage","Node3D",preload("Class/World/ScenesPackageClass.gd"),preload("Class/World/ScenesPackageIcon.svg"))
	add_custom_type("ChunkPath","Resource",preload("Class/World/ChunkClass.gd"),preload("Class/World/ChunkPathIcon.svg"))

func _exit_tree() -> void:
	remove_custom_type("ScenesPackage")
	remove_custom_type("ChunkPath")
