extends Control

@onready var desktop: TextureRect = $Desktop
@onready var cursor: Sprite2D = $Desktop/Cursor
@onready var start_screen: Control = $StartScreen

func _ready() -> void:
	desktop.hide()
	desktop.process_mode = Node.PROCESS_MODE_DISABLED
	start_screen.show()
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(start_screen, "visible", false, 0).set_delay(3)
	tween.tween_property(desktop, "visible", true, 0).set_delay(1)
	tween.tween_callback(func():desktop.process_mode = Node.PROCESS_MODE_INHERIT)
