@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("KCT_kmTranslator","Keyboard&Mouse/km_translator.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("KCT_kmTranslator")
