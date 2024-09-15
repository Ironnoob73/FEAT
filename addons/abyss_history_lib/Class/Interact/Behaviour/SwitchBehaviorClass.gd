extends BehaviorClass
class_name SwitchBehaviorClass

@export var connected_node : Array[NodePath]

func do(sender):
	for i in connected_node :
		var Ni = sender.get_node(i)
		if Ni.is_in_group("Switchable") :
			Ni.switch(sender.state)
		else : push_warning("This connected node can't be switched.")
