extends AHL_BehaviorClass
class_name AHL_DebugPrintBehaviorClass

@export var text : String = ''

func do(interactor,sender):
	sender.chat_menu.send_message("[Debug: " + text + "]")
