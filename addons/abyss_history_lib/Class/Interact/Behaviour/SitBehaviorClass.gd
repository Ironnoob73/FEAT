extends AHL_BehaviorClass
class_name AHL_SitBehaviorClass
## 椅子行为，令交互者坐在自身指定位置。

func do(interactor,sender):
	sender.sit( interactor.global_position + Vector3(0,0,0), interactor.global_rotation)
