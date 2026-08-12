extends AHL_BehaviorClass
class_name AHL_ConditionBehaviorClass
## 根据获取到的值是否为期望值而决定执行的行为的行为

@export var is_sender: bool = false
@export var tag: String = ''
@export var expected_value: Variant
@export var true_behavior: AHL_BehaviorClass = null
@export var false_behavior: AHL_BehaviorClass = null

func do(interactor: AHL_Interactive, sender: Node) -> void:
	if tag != '':
		#var result: String = ''
		if not is_sender:
			if interactor.get(tag):
				if interactor.get(tag) == expected_value:
					if true_behavior:
						true_behavior.do(interactor, sender)
					return
		elif sender.get(tag):
			if sender.get(tag) == expected_value:
				true_behavior.do(interactor, sender)
				return
	if false_behavior:
		false_behavior.do(interactor, sender)
