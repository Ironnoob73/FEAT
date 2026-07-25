extends AHL_BehaviorClass
class_name AHL_CaptionClass
## 显示字幕行为。

@export var text : String = ''

func do(interactor:Node,sender:Node) -> void:
	sender.add_caption(text)
