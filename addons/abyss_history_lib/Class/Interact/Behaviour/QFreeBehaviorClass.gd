extends AHL_BehaviorClass
class_name AHL_QFreeBehaviorClass
## 将自身删除的行为。

func do(interactor:Node,sender:Node) -> void:
	interactor.queue_free()
