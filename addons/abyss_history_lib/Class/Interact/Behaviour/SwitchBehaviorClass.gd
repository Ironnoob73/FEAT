extends AHL_BehaviorClass
class_name AHL_SwitchBehaviorClass
## 开关行为，交互时同时调整连接到自身的节点。

@export var connected_node : Array[NodePath]

func do(interactor,sender):
	for i in connected_node :
		var Ni = interactor.get_node(i)
		if Ni.is_in_group("Switchable") :
			Ni.switch(interactor.state)
		else : push_warning("This connected node can't be switched.")
