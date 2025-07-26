extends CanvasLayer

var _action: String = ""

@onready var v_list: VBoxContainer = $Background/PanelContainer/VBox
@onready var action_name: Label = $Background/PanelContainer/VBox/ActionName
@onready var key_read: Button = $Background/PanelContainer/VBox/HBox/KeyRead
@onready var add_button: Button = $Background/PanelContainer/VBox/HBox/AddButton

var candidate_event: InputEvent = null
var listening: bool = false

func _ready() -> void:
	key_read.grab_focus()

func setup_keybind(action: String) -> void:
	_action = action
	action_name.text = "keybind." + action
	refresh_list()
	
func refresh_list() -> void:
	for i in v_list.get_children():
		if i is HBoxContainer and i.name != "HBox":
			i.queue_free()
	var previous_node: Node = action_name
	for i in Global.get_key_event_array(_action):
		var HBox: HBoxContainer = HBoxContainer.new()
		previous_node.add_sibling(HBox)
		previous_node = HBox
		# Key name label
		var KeyLabel: Label = Label.new()
		previous_node.add_child(KeyLabel)
		KeyLabel.text = i.as_text()
		KeyLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		KeyLabel.set_h_size_flags(Control.SIZE_SHRINK_CENTER + Control.SIZE_EXPAND)
		# Unbind button
		var UnbindButton: Button = Button.new()
		previous_node.add_child(UnbindButton)
		UnbindButton.text = "-"
		UnbindButton.custom_minimum_size.x = 35
		UnbindButton.pressed.connect(_on_remove_event.bind(i))
	Global.save_settings_to_file("keybindings",_action,InputMap.action_get_events(_action))
	
func _input(event: InputEvent) -> void:
	if listening and event is not InputEventMouseMotion:
		key_read.text = event.as_text()
		candidate_event = event
		listening = false
		await get_tree().create_timer(1).timeout
		key_read.grab_focus()

func exit() -> void:
	self.queue_free()

func _on_add_button_pressed() -> void:
	if InputMap.action_get_events(_action).find(candidate_event) == -1:
		InputMap.action_add_event(_action,candidate_event)
	candidate_event = null
	key_read.text = "options.control.keybindings.listen"
	refresh_list()

func _on_key_read_pressed() -> void:
	listening = true
	key_read.release_focus()
	key_read.text = "options.control.keybindings.listening"

func _on_remove_event(event: InputEvent) -> void:
	if InputMap.action_has_event(_action, event):
		InputMap.action_erase_event(_action, event)
	refresh_list()
