extends AHL_BehaviorClass
class_name AHL_DebugPrintBehaviorClass
## 在聊天栏打印字符串的行为。

@export var text : String = ''

func do(_interactor: AHL_Interactive, sender: Node) -> void:
	if sender is CharacterBody3D and sender.has_method("append_message"):
		var player_sender: CharacterBody3D = sender
		@warning_ignore("unsafe_method_access")
		player_sender.append_message("[Debug: " + text + "]")
