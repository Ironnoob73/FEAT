extends AHL_BehaviorClass
class_name AHL_SitBehaviorClass
## 椅子行为，令交互者坐在自身指定位置。

func do(interactor:Node,sender:Node) -> void:
	if !interactor.has_meta("user"):
		sender.sit(interactor.global_position + Vector3(0,0,0), interactor.global_rotation)
		interactor.set_meta("user", sender)
		sender.isSit = interactor
	elif interactor.get_meta("user") == sender:
		interactor.remove_meta("user")
		sender._un_sit()
