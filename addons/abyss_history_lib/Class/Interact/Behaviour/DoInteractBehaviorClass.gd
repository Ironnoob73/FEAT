extends AHL_BehaviorClass
class_name AHL_DoInteractBehaviorClass
## 使发送者与自己直接交互的行为，如玩家靠近掉落物时，若在接触行为列表里添加此项，则相当于玩家与掉落物直接交互并执行捡起物品的行为。

func do(interactor:Node,sender:Node) -> void:
	interactor.interact(sender)
