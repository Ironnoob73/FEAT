@tool
extends EditorPlugin

func _enter_tree() -> void:
	# Scene Package
	add_custom_type("AHL_ScenesPackage","Node3D",preload("Class/World/ScenesPackageClass.gd"),preload("Class/World/ScenesPackageIcon.svg"))
	add_custom_type("AHL_ChunkPath","Resource",preload("Class/World/ChunkClass.gd"),preload("Class/World/ChunkPathIcon.svg"))
	add_custom_type("AHL_RoomInstance","Resource",preload("Class/World/RoomClass.gd"),preload("Class/World/RoomInstanceIcon.svg"))
	# Interact
	add_custom_type("AHL_Interactive","Node3D",preload("Class/Interact/InteractiveClass.gd"),preload("Class/Interact/InteractiveIcon.svg"))
	#	Attack
	#add_custom_type("Hurtable","AHL_Interactive",preload("Class/Interact/Attack/HurtableClass.gd"),preload("Class/Interact/Attack/HurtableIcon.svg"))

	# Notice
	add_autoload_singleton("AHL_NoticeManager","Scene/Notice/NoticeManager.gd")
	add_custom_type("AHL_NoticeInfo","Node3D",preload("Class/Notice/NoticeInfoClass.gd"),preload("Class/Interact/InteractiveIcon.svg"))

func _exit_tree() -> void:
	remove_custom_type("AHL_ScenesPackage")
	remove_custom_type("AHL_ChunkPath")
	remove_custom_type("AHL_RoomInstance")
	
	remove_custom_type("AHL_Interactive")
	#remove_custom_type("AHL_Hurtable")
	
	remove_autoload_singleton("AHL_NoticeManager")
	remove_custom_type("AHL_NoticeInfo")
