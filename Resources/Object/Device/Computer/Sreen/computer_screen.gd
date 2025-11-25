extends TextureRect

@onready var time_label: Label = $BottomTab/HBox/Time

@onready var files_icon: Button = $DesktopIcons/FilesIcon
@onready var files_icon_name: Label = $DesktopIcons/FilesIcon/NameTag

@onready var window_class = preload("res://Resources/Object/Device/Computer/Sreen/window.tscn")
@onready var window_frame_anim: NinePatchRect = $WindowFrameAnim

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
	add_child(window)
	window.icon.texture = files_icon.icon
	window.title.text = files_icon_name.text
	var tween = create_tween()
	tween.tween_property(window_frame_anim,"size",window.size,0.25)
	tween.set_parallel().tween_property(window_frame_anim,"position",window.position,0.25)
	tween.set_parallel(false).tween_callback(func():window_frame_anim.hide())
	tween.tween_callback(func():window.show())
