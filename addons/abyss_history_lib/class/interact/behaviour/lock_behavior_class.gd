extends AHL_BehaviorClass
class_name AHL_LockBehaviorClass
## 对自身上锁的行为，如果玩家没有持有对应“钥匙”或没有解锁则无法进行交互。

@export var unlock : bool = true
@export var lock : int = 0

func do(interactor: AHL_Interactive, _sender: Node) -> void:
	interactor.set_meta('lock_int',lock)
	interactor.Interactable = false
	interactor.interact_icon = "🔒"
	interactor.interact_text = "interact.locked"
