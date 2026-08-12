extends AHL_BehaviorClass
class_name AHL_DebugPrintInfoBehaviorClass
## 在聊天栏打印自身相关信息的行为。

@export var is_sender : bool = false
@export var tag : String = ''

func do(interactor: AHL_Interactive, sender: Node) -> void:
	if sender is Player and tag != '':
		var result : String = ''
		if !is_sender:
			if interactor.get(tag):
				result = 'interactor.' + tag + ':' + str(interactor.get(tag))
		elif sender.get(tag):
			result = 'sender.' + tag + ':' + str(sender.get(tag))
		if sender is LocalPlayer:
			var player_sender: LocalPlayer = sender
			player_sender.chat_menu.append_message("[Debug: " + result + "]")
