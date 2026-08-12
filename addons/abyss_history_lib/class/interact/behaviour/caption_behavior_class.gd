extends AHL_BehaviorClass
class_name AHL_CaptionClass
## 显示字幕行为。

@export var text: String = ''

func do(_interactor: AHL_Interactive, sender: Node) -> void:
	if sender is LocalPlayer:
		var player_sender: LocalPlayer = sender
		player_sender.add_caption(text)
