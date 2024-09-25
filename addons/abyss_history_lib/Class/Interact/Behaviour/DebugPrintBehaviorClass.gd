extends BehaviorClass
class_name DebugPrintBehaviorClass

@export var text : String = ''

func do(interactor,sender):
	sender.chat_menu.send_message("[Debug: " + text + "]")
