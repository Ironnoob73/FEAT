extends BehaviorClass
class_name SwitchBehaviorClass

@export var connected_node : Array[NodePath]

func do(interactor,sender):
	for i in connected_node :
		var Ni = interactor.get_node(i)
		if Ni.is_in_group("Switchable") :
			Ni.switch(interactor.state)
		else : push_warning("This connected node can't be switched.")
