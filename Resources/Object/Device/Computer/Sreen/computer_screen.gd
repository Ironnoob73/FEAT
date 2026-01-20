extends Control

@onready var desktop: TextureRect = $Desktop
@onready var cursor: Sprite2D = $Cursor
@onready var start_screen: Control = $StartScreen
@onready var welcome_screen: TextureRect = $WelcomeScreen

@onready var bottom_tab: PanelContainer = $Desktop/BottomTab
@onready var start_button: Button = $Desktop/BottomTab/HBox/StartButton
@onready var time: Label = $Desktop/BottomTab/HBox/Time
@onready var desktop_icons: VFlowContainer = $Desktop/DesktopIcons

func _ready() -> void:
	start_screen.hide()
	welcome_screen.hide()
	if !Global.FastBoot or Global.oobe:
		cursor.hide()
		desktop.hide()
		
		desktop.process_mode = Node.PROCESS_MODE_DISABLED
		start_screen.show()
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_callback(func():start_screen.hide()).set_delay(5)
		tween.tween_callback(func():cursor.show()).set_delay(1)
		if !Global.oobe:
			tween.tween_callback(func():ready_desktop()).set_delay(1)
		else:
			tween.tween_callback(func():add_child(load("res://Assets/UI/Computer/oobe.tscn").instantiate()))
	else:
		cursor.show()
		desktop.show()
		start_screen.hide()

func ready_desktop() -> void:
	welcome_screen.show()
	bottom_tab.hide()
	start_button.hide()
	time.hide()
	for i in desktop_icons.get_children():
		i.hide()
	desktop.show()
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func():welcome_screen.hide()).set_delay(3)
	tween.tween_callback(func():desktop.show())
	tween.tween_callback(func():desktop.process_mode = Node.PROCESS_MODE_INHERIT)
	tween.tween_callback(func():Global.THE_PLAYER.remove_meta("lock_hud_hidden"))
	tween.tween_callback(func():Global.THE_PLAYER.remove_meta("lock_menu"))
	tween.tween_callback(func():bottom_tab.show()).set_delay(0.5)
	tween.tween_callback(func():start_button.show()).set_delay(0.5)
	tween.tween_callback(func():time.show()).set_delay(0.1)
	for i in desktop_icons.get_children():
		tween.tween_callback(func():i.show()).set_delay(0.1)
