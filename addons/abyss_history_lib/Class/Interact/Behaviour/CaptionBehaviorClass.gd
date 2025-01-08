extends AHL_BehaviorClass
class_name AHL_CaptionClass
## 显示字幕行为。

@export var text : String = ''

func do(interactor,sender):
	sender.add_caption(text)
