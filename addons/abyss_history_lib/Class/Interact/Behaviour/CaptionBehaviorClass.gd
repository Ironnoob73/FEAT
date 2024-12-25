extends AHL_BehaviorClass
class_name AHL_CaptionClass

@export var text : String = ''

func do(interactor,sender):
	sender.add_caption(text)
