extends Control
@onready var key_string: Label = $KeyString

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		key_string.text = event.as_text()

func _on_exit_button_pressed() -> void:
	Global.back_to_title()
