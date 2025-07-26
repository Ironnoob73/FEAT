extends VBoxContainer

var _keybind_screen = preload("res://Assets/UI/Options/KeybindScene.tscn")

var action_group: Array[String] = ["ui_up","ui_down","ui_left","ui_right"]

func _ready() -> void:
	for i in get_children():
		i.queue_free()
	for i in action_group:
		var event_array = Global.load_settings_from_file("keybindings",i,null)
		if event_array != null:
			InputMap.action_erase_events(i)
			for j in event_array:
				InputMap.action_add_event(i,j)
		var container: HBoxContainer = HBoxContainer.new()
		add_child(container)
		container.name = i
		var text: Label = Label.new()
		container.add_child(text)
		text.text = "keybind." + i
		var button: Button = Button.new()
		container.add_child(button)
		button.text = key_array_to_string(i)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.clip_text = true
		button.custom_minimum_size.x = 200
		button.set_h_size_flags(SIZE_SHRINK_END + SIZE_EXPAND)
		button.pressed.connect(start_keybind.bind(i))

func key_array_to_string(action: String) -> String:
	var array = Global.get_key_array(action)
	return str(array).replacen("\"","").replacen("[","").replacen("]","")

func start_keybind(action: String) -> void:
	var keybind_screen = _keybind_screen.instantiate()
	get_tree().get_root().add_child(keybind_screen)
	keybind_screen.setup_keybind(action)
	keybind_screen.tree_exited.connect(_ready)
