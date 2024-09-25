extends PanelContainer

@onready var input_bar: HBoxContainer = $VBoxContainer/InputBar
@onready var edit: LineEdit = $VBoxContainer/InputBar/Edit
@onready var chat_list: RichTextLabel = $VBoxContainer/RichTextLabel

var isInput : bool = false:
	set(state):
		isInput = state
		chat_state()
		
func _ready() -> void:
	chat_state()
	
func chat_state():
	if isInput:
		self_modulate.a = 1
		input_bar.show()
		chat_list.set_focus_mode(FOCUS_ALL)
	else :
		self_modulate.a = 0
		input_bar.hide()
		chat_list.release_focus()
		chat_list.set_focus_mode(FOCUS_NONE)

func send_message(message:String):
	chat_list.append_text(message)
	chat_list.pop_all()
	chat_list.newline()
	
func _on_send_button_pressed() -> void:
	if get_parent() is CharacterBody3D:
		send_message(get_parent().get_player_name() + ": " + edit.text)
