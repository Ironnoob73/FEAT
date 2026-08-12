extends VBoxContainer

var _keybind_screen: PackedScene = preload("res://assets/ui/options/keybind_scene.tscn")

var action_group: Array[String] = [
	"ui_up","ui_down","ui_left","ui_right",
	"ui_cancel"
	]

func _ready() -> void:
	for i: Control in get_children():
		i.queue_free()
	for i: String in action_group:
		var container: HBoxContainer = HBoxContainer.new()
		add_child(container)
		container.name = i
		var text: Label = Label.new()
		container.add_child(text)
		text.text = "keybind." + i
		var restore: Button = Button.new()
		container.add_child(restore)
		restore.icon = preload("res://resources/image/ui/restore.svg")
		restore.flat = true
		restore.set_h_size_flags(SIZE_SHRINK_END + SIZE_EXPAND)
		restore.theme = preload("res://assets/ui/options/restore_button_scene.tres")
		var _connect: int = restore.pressed.connect(keybingding_restore.bind(i))
		var button: Button = Button.new()
		container.add_child(button)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.clip_text = true
		button.custom_minimum_size.x = 200
		_connect = button.pressed.connect(start_keybind.bind(i))
		
		# Overwrite keybindings from custom settings
		var event_array: Array = Global.load_settings_from_file("keybindings", i, ProjectSettings.get_setting("input/"+i)["events"])
		#print(event_array, ProjectSettings.get_setting("input/"+i)["events"], event_array == ProjectSettings.get_setting("input/"+i)["events"])
		if event_array != ProjectSettings.get_setting("input/"+i)["events"]:
			InputMap.action_erase_events(i)
			for j: InputEvent in event_array:
				InputMap.action_add_event(i,j)
		else:
			restore.set_disabled(true)
			
		button.text = key_array_to_string(i)
		button.set_theme(preload("res://addons/key_controls_translator/keyboard_and_mouse/km_font_theme.tres"))

func key_array_to_string(action: String) -> String:
	var result: String = ""
	var array: Array = Global.get_key_event_array(action)
	for i: InputEvent in array:
		var keyName: String = i.as_text()
		var keyIcon: Variant = KmTranslator.get_key_from_name(keyName)
		if keyIcon or keyName.length() == 1:
			result += keyName if keyIcon == null else keyIcon
	return result
	
func keybingding_restore(action: String) -> void:
	InputMap.action_erase_events(action)
	for i: InputEvent in ProjectSettings.get_setting("input/"+action)["events"]:
		InputMap.action_add_event(action,i)
	Global.save_settings_to_file("keybindings", action, InputMap.action_get_events(action))
	_ready()

func start_keybind(action: String) -> void:
	var keybind_screen: CanvasLayer = _keybind_screen.instantiate()
	get_tree().get_root().add_child(keybind_screen)
	var keybind_window: KeybindWindow = keybind_screen.get_child(0).get_child(0)
	keybind_window.setup_keybind(action)
	var _connect: int = keybind_screen.tree_exited.connect(_ready)
