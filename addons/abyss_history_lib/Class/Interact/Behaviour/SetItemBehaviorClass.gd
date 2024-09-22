@tool
extends BehaviorClass
class_name SetItemBehaviorClass

@export var ThingInstance : ThingInstanceClass
		
func do(interactor,sender):
	interactor.set_meta('thing_instance',ThingInstance)
