extends BehaviorClass
class_name DebugPrintInfoBehaviorClass

@export var isSender : bool = false
@export var tag : String = ''

func do(interactor,sender):
	if tag != '':
		if !isSender:
			if interactor.get(tag):
				print(interactor.get(tag))
		elif sender.get(tag):
			print(sender.get(tag))
