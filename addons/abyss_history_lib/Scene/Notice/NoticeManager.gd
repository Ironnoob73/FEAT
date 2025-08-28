extends Node

var _notice_screen = preload("notice_scene.tscn")
var is_notice_show : bool = false

func show_notice(notice_info:AHL_NoticeInfo) -> void :
	is_notice_show = true
	var notice_screen = _notice_screen.instantiate()
	get_tree().get_root().add_child(notice_screen)
	notice_screen.get_notice_info(notice_info)
