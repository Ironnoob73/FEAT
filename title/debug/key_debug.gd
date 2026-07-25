extends Control
@onready var key_string: Label = $VBoxContainer/KeyString
@onready var key_inner_array: Label = $VBoxContainer/KeyInnerArray
@onready var detect_mouse: CheckBox = $HBoxContainer/DetectMouse

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion or detect_mouse.button_pressed:
		key_string.text = event.as_text()
		key_inner_array.text = event.to_string()

func _on_exit_button_pressed() -> void:
	Global.back_to_title()
