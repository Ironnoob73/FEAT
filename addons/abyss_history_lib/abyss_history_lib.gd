@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("AHL_Core", "abyss_history_lib_core.gd")
	
func _exit_tree() -> void:
	remove_autoload_singleton("AHL_Core")
