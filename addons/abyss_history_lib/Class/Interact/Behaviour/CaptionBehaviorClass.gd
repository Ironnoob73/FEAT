extends BehaviorClass
class_name CaptionClass

@export var text : String = ''

func do(interactor,sender):
	sender.add_caption(text)
