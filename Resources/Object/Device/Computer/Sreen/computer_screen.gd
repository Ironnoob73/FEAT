extends Control
class_name ComputerScreen

@onready var desktop: TextureRect = $Desktop
@onready var cursor: Sprite2D = $Cursor
@onready var start_screen: Control = $StartScreen
@onready var welcome_screen: TextureRect = $WelcomeScreen

@onready var bottom_tab: PanelContainer = $Desktop/BottomTab
@onready var start_button: Button = $Desktop/BottomTab/HBox/StartButton
@onready var time: Label = $Desktop/BottomTab/HBox/Time
@onready var desktop_icons: VFlowContainer = $Desktop/DesktopIcons
@onready var window_group: Control = $Desktop/WindowGroup

var is_offing: bool = false
@onready var off_screen: TextureRect = $OffScreen
signal offing

func _ready() -> void:
	start_screen.hide()
	welcome_screen.hide()
	off_screen.hide()
	if !Global.FastBoot or Global.oobe:
		cursor.hide()
		desktop.hide()
		
		desktop.process_mode = Node.PROCESS_MODE_DISABLED
		start_screen.show()
		var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		var _c_tween: CallbackTweener = null
		_c_tween = tween.tween_callback(func()->void:start_screen.hide()).set_delay(5)
		_c_tween = tween.tween_callback(func()->void:cursor.show()).set_delay(1)
		if !Global.oobe:
			_c_tween = tween.tween_callback(func()->void:ready_desktop()).set_delay(1)
		else:
			var oobe_interface: PackedScene = load("res://Assets/UI/Computer/oobe.tscn")
			_c_tween = tween.tween_callback(func()->void:add_child(oobe_interface.instantiate()))
	else:
		cursor.show()
		desktop.show()
		start_screen.hide()

func ready_desktop() -> void:
	welcome_screen.show()
	bottom_tab.hide()
	start_button.hide()
	time.hide()
	for i: Button in desktop_icons.get_children():
		i.hide()
	desktop.show()
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var _c_tween: CallbackTweener = null
	_c_tween = tween.tween_callback(func()->void:welcome_screen.hide()).set_delay(3)
	_c_tween = tween.tween_callback(func()->void:desktop.show())
	_c_tween = tween.tween_callback(func()->void:desktop.process_mode = Node.PROCESS_MODE_INHERIT)
	_c_tween = tween.tween_callback(func()->void:Global.CurrentWorld.player0.remove_meta("lock_hud_hidden"))
	_c_tween = tween.tween_callback(func()->void:Global.CurrentWorld.player0.remove_meta("lock_menu"))
	_c_tween = tween.tween_callback(func()->void:bottom_tab.show()).set_delay(0.5)
	_c_tween = tween.tween_callback(func()->void:start_button.show()).set_delay(0.5)
	_c_tween = tween.tween_callback(func()->void:time.show()).set_delay(0.1)
	for i: Button in desktop_icons.get_children():
		_c_tween = tween.tween_callback(func()->void:i.show()).set_delay(0.1)

func _on_off_button_pressed() -> void:
	if !is_offing:
		Global.CurrentWorld.player0.set_meta("lock_hud_hidden",true)
		Global.CurrentWorld.player0.set_meta("lock_menu",true)
		start_button.button_pressed = false
		is_offing = true
		var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		var _c_tween: CallbackTweener = null
		_c_tween = tween.tween_callback(func()->void:offing.emit())
		_c_tween = tween.tween_callback(func()->void:desktop_icons.hide()).set_delay(1)
		_c_tween = tween.tween_callback(func()->void:window_group.hide()).set_delay(1)
		_c_tween = tween.tween_callback(func()->void:start_button.hide()).set_delay(1)
		_c_tween = tween.tween_callback(func()->void:time.hide()).set_delay(0.1)
		_c_tween = tween.tween_callback(func()->void:bottom_tab.hide()).set_delay(0.5)
		_c_tween = tween.tween_callback(func()->void:cursor.hide()).set_delay(0.5)
		_c_tween = tween.tween_callback(func()->void:off_screen.show()).set_delay(1)
		_c_tween = tween.tween_callback(func()->void:hide()).set_delay(5)
		_c_tween = tween.tween_callback(func()->void:get_tree().quit()).set_delay(0.5)
