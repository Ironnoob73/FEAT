extends VBoxContainer

@onready var title_screen: Control = $"../../../.."

func get_current_menu() -> String:
	return title_screen.current_menu
