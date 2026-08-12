extends AHL_BehaviorClass
class_name AHL_DebugPrintBehaviorClass
## 在聊天栏打印字符串的行为。

@export var text : String = ''

func do(_interactor: AHL_Interactive, sender: Node) -> void:
	if sender is LocalPlayer:
		var player_sender: LocalPlayer = sender
		player_sender.chat_menu.append_message("[Debug: " + text + "]")
