extends TextureRect

@onready var time_label: Label = $BottomTab/HBox/Time

@onready var files_icon: Button = $DesktopIcons/FilesIcon

func _process(_delta: float) -> void:
	var time_dict : Dictionary = Time.get_time_dict_from_system()
	time_label.text = str("%02d" % time_dict.get("hour"), ":", "%02d" % time_dict.get("minute"), " ")
