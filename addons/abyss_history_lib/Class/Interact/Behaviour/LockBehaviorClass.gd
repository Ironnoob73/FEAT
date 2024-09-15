extends BehaviorClass
class_name LockBehaviorClass

@export var unlock : bool = true
@export var lock : int = 0

func do(sender):
	sender.set_meta('lock_int',lock)
	if !unlock:
		sender.interact_icon = "🔒"
