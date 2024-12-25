@tool
extends AHL_BehaviorClass
class_name AHL_SetItemBehaviorClass

@export var ThingInstance : AHL_ThingInstanceClass
		
func do(interactor,sender):
	interactor.set_meta('thing_instance',ThingInstance)
