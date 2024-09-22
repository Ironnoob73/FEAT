extends BehaviorClass
class_name GiveItemBehaviorClass

@export var ThingInstance : ThingInstanceClass

func do(interactor,sender):
	if !ThingInstance:
		ThingInstance = interactor.get_meta('thing_instance',null)
	sender.Inventory.add_instance(ThingInstance)
