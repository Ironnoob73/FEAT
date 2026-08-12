extends Button

@export var notice: AHL_NoticeInfo = AHL_NoticeInfo.new()

func _on_pressed() -> void:
	AHL_Notice.show_notice(notice)
