extends AHL_BehaviorClass
class_name AHL_DebugPrintBehaviorClass
## 在聊天栏打印字符串的行为。

@export var text : String = ''

func do(interactor,sender):
	sender.chat_menu.send_message("[Debug: " + text + "]")
