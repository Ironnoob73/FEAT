extends AHL_BehaviorClass
class_name AHL_SitBehaviorClass

func do(interactor,sender):
	sender.sit( interactor.global_position + Vector3(0,0,0), interactor.global_rotation)
