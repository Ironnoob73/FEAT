extends PanelContainer
class_name PlayerChat

@onready var input_bar: HBoxContainer = $VBoxContainer/InputBar
@onready var edit: LineEdit = $VBoxContainer/InputBar/Edit
@onready var chat_list: RichTextLabel = $VBoxContainer/RichTextLabel
@onready var send_button: Button = $VBoxContainer/InputBar/SendButton

var send_history : Array[String] = []
var current_history : int = -1
var last_input: String = ""

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

func append_message(message:String):
	chat_list.append_text(message)
	chat_list.pop_all()
	chat_list.newline()

func send_message():
	if edit.text != "":
		if edit.text.begins_with("#"):
			if Commands.has_method(edit.text.trim_prefix("#").get_slice("(",0)):
				var command = Callable(Commands,edit.text.trim_prefix("#").get_slice("(",0))
				var argu_in:Array = [get_parent()]
				if edit.text.contains("("):
					argu_in.append_array(edit.text.trim_prefix("#").get_slice("(",1).trim_suffix(")").split(","))
				if command.get_argument_count() == argu_in.size():
					command.callv(argu_in)
				else:
					append_message("[i]Parameter count mismatch, expect %s, got %s.[/i]" \
						% [str(command.get_argument_count()),argu_in])
			else:
				append_message("[i]No command called %s.[/i] " % edit.text.trim_prefix("#").get_slice("(",0))
		elif get_parent() is player and edit.text != "":
			append_message(get_parent().get_player_name() + ": " + edit.text)
		send_history.append(edit.text)
	edit.text = ""
	last_input = ""
	current_history = -1

func append_history(up:bool = true):
	if current_history == -1:
		last_input = edit.text
	if send_history.size() != 0:
		if up:
			if current_history == -1:
				current_history = send_history.size() -1
			elif current_history != 0:
				current_history -= 1
		else:
			if current_history == -1:
				pass
			elif current_history == send_history.size() -1:
				current_history = -1
			elif current_history < send_history.size() -1:
				current_history += 1
	if send_history.size() != 0 and current_history != -1 and current_history <= send_history.size() -1:
		edit.text = send_history[current_history]
		edit.set_caret_column.call_deferred(edit.text.length())
	else:
		current_history = -1
		edit.text = last_input
	
func _on_send_button_pressed() -> void:
	send_message()

func _input(_event: InputEvent) -> void:
	if isInput:
		if Input.is_action_just_pressed("ui_text_submit"):		send_message()
		if Input.is_action_just_pressed("ui_text_caret_up"):	append_history()
		if Input.is_action_just_pressed("ui_text_caret_down"):	append_history(false)
