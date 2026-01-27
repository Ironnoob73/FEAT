extends TextureRect

@onready var time_label: Label = $BottomTab/HBox/Time

@onready var files_icon: Button = $DesktopIcons/FilesIcon
@onready var files_icon_name: Label = $DesktopIcons/FilesIcon/NameTag

@onready var window_group: Control = $WindowGroup
@onready var window_class = preload("res://Resources/Object/Device/Computer/Sreen/window.tscn")
@onready var window_frame_anim: NinePatchRect = $WindowFrameAnim
@onready var windows_tab_bar: TabBar = $BottomTab/HBox/MarginContainer/TabBar

@onready var start_button: Button = $BottomTab/HBox/StartButton
var isStartMenuOpen: bool = false
var isStartMenuHover: bool = false
@onready var start_menu: Panel = $StartMenu
@onready var user_avatar: Button = $StartMenu/VBoxContainer/Title/Avatar
@onready var user_name: Label = $StartMenu/VBoxContainer/Title/VBoxContainer/Name
@onready var user_duid: Label = $StartMenu/VBoxContainer/Title/VBoxContainer/DUID
# Off icon from: https://www.svgrepo.com/svg/391925/off

func _ready() -> void:
	start_menu.hide()

func _process(_delta: float) -> void:
	var time_dict : Dictionary = Time.get_time_dict_from_system()
	time_label.text = str("%02d" % time_dict.get("hour"), ":", "%02d" % time_dict.get("minute"), " ")

func _on_files_icon_pressed() -> void:
	move_child(window_frame_anim,-1)
	window_frame_anim.size = files_icon.size
	window_frame_anim.position = files_icon.position
	window_frame_anim.show()
	var window = window_class.instantiate()
	window.hide()
	window_group.add_child(window)
	window.icon.texture = files_icon.icon
	window.title.text = files_icon_name.text
	var tween = create_tween()
	tween.tween_property(window_frame_anim,"size",window.size,0.25)
	tween.set_parallel().tween_property(window_frame_anim,"position",window.position,0.25)
	tween.set_parallel(false).tween_callback(func():window_frame_anim.hide())
	tween.tween_callback(func():window.show())
	windows_tab_bar.add_tab(files_icon_name.text, files_icon.icon)

func _on_start_button_toggled(toggled_on: bool) -> void:
	if !get_parent().is_offing:
		var tween = create_tween()
		isStartMenuOpen = toggled_on
		if toggled_on:
			tween.tween_callback(func():start_menu.show())
			tween.tween_property(start_menu,"position:y",215,0.25)
			user_name.text = Global.playerName
			user_duid.text = Global.duid
			user_avatar.icon = Global.avatar
		else:
			tween.tween_property(start_menu,"position:y",768,0.25)
			tween.tween_callback(func():start_menu.hide())
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton\
	and event.button_index == 1\
	and event.is_pressed\
	and isStartMenuOpen:
		handle_mouse_click()
		
func handle_mouse_click() -> void:
	if !isStartMenuHover:
		start_button.button_pressed = false

func _on_start_menu_mouse_entered() -> void:	isStartMenuHover = true
func _on_start_menu_mouse_exited() -> void:		isStartMenuHover = false
