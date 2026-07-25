@tool
extends EditorPlugin

func _enter_tree() -> void:
	# Scene Package
	add_custom_type("AHL_ScenesPackage","Node3D",preload("class/world/scenes_package_class.gd"),preload("class/world/scenes_package_icon.svg"))
	add_custom_type("AHL_ChunkPath","Resource",preload("class/world/chunk_class.gd"),preload("class/world/chunk_path_icon.svg"))
	add_custom_type("AHL_RoomInstance","Resource",preload("class/world/room_class.gd"),preload("class/world/room_instance_icon.svg"))
	# Interact
	add_custom_type("AHL_Interactive","Node3D",preload("class/interact/interactive_class.gd"),preload("class/interact/interactive_icon.svg"))
	
	# Load
	add_autoload_singleton("AHL_LoadManager","scene/loading_screen/load_manager.gd")
	# Notice
	add_autoload_singleton("AHL_NoticeManager","scene/notice/notice_manager.gd")
	add_custom_type("AHL_NoticeInfo","Node3D",preload("class/notice/notice_info_class.gd"),preload("class/notice/info.svg"))

func _exit_tree() -> void:
	remove_custom_type("AHL_ScenesPackage")
	remove_custom_type("AHL_ChunkPath")
	remove_custom_type("AHL_RoomInstance")
	
	remove_custom_type("AHL_Interactive")
	
	remove_autoload_singleton("AHL_LoadManager")
	
	remove_autoload_singleton("AHL_NoticeManager")
	remove_custom_type("AHL_NoticeInfo")
