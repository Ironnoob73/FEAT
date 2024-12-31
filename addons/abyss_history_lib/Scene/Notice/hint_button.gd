extends Button

@export var notice: AHL_NoticeInfo = AHL_NoticeInfo.new()

func _on_pressed() -> void:
	AHL_NoticeManager.show_notice(notice)
