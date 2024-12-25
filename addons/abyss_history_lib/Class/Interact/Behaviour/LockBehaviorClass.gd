extends AHL_BehaviorClass
class_name AHL_LockBehaviorClass

@export var unlock : bool = true
@export var lock : int = 0

func do(interactor,sender):
	interactor.set_meta('lock_int',lock)
	if !unlock:
		interactor.Interactable = false
		interactor.interact_icon = "🔒"
		interactor.interact_text = "locked"
