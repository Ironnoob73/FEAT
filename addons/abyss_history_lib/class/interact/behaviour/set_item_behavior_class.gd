@tool
extends AHL_BehaviorClass
class_name AHL_SetItemBehaviorClass
## 设置自身是什么物品，主要用于设置掉落物。

@export var ThingInstance : AHL_ThingInstanceClass
		
func do(interactor:Node,sender:Node) -> void:
	interactor.set_meta('thing_instance',ThingInstance)
