extends AHL_BehaviorClass
class_name AHL_DebugPrintBehaviorClass
## 在聊天栏打印字符串的行为。

@export var text : String = ''

func do(interactor,sender):
	if sender is player:
		sender.chat_menu.append_message("[Debug: " + text + "]")
