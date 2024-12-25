extends AHL_BehaviorClass
class_name AHL_GiveItemBehaviorClass

@export var ThingInstance : AHL_ThingInstanceClass

func do(interactor,sender):
	if !ThingInstance:
		ThingInstance = interactor.get_meta('thing_instance',null)
	sender.Inventory.add_instance(ThingInstance)
