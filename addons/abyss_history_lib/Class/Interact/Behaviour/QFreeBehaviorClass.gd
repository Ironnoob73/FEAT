extends AHL_BehaviorClass
class_name AHL_QFreeBehaviorClass
## 将自身删除的行为。

func do(interactor,sender):
	interactor.queue_free()
