extends AHL_BehaviorClass
class_name AHL_DebugPrintInfoBehaviorClass
## 在聊天栏打印自身相关信息的行为。

@export var isSender : bool = false
@export var tag : String = ''

func do(interactor,sender):
	if tag != '':
		var result : String = ''
		if !isSender:
			if interactor.get(tag):
				result = 'interactor.' + tag + ':' + str(interactor.get(tag))
		elif sender.get(tag):
			result = 'sender.' + tag + ':' + str(sender.get(tag))
		sender.chat_menu.send_message("[Debug: " + result + "]")
