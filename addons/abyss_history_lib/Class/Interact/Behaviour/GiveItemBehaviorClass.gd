extends AHL_BehaviorClass
class_name AHL_GiveItemBehaviorClass
## 给予交互者物品的行为。如果未设置物品则尝试使用由[AHL_SetItemBehaviorClass]设置的物品。

@export var ThingInstance : AHL_ThingInstanceClass

func do(interactor:Node,sender:Node) -> void:
	if !ThingInstance:
		ThingInstance = interactor.get_meta('thing_instance',null)
	sender.Inventory.add_instance(ThingInstance)
