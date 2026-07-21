extends AHL_BehaviorClass
class_name AHL_SwitchBehaviorClass
## 开关行为，交互时同时调整连接到自身的节点。

@export var connected_node : Array[NodePath]
@export_enum("Interact", "Reversal", "On", "Off", "Sync", "AntiSync") var switch_to : String = "Interact"

func do(interactor:Node,sender:Node) -> void:
	for i in connected_node :
		var Ni = interactor.get_node(i)
		if Ni.is_in_group("Switchable") :
			Ni.switch(interactor.state)
		if Ni is AHL_Interactive:
			var INi: AHL_Interactive = Ni
			if INi.Switchable:
				match switch_to:
					"Reversal": INi.switch(!interactor.state, sender)
					"On": INi.switch(true, sender)
					"Off": INi.switch(false, sender)
					"Sync":
						if sender is AHL_Interactive or sender.is_in_group("Switchable"):
							INi.switch(sender.state, sender)
					"AntiSync":
						if sender is AHL_Interactive or sender.is_in_group("Switchable"):
							INi.switch(!sender.state, sender)
					"Interact", _:
						INi.interact(sender)
		else : push_warning("This connected node can't be switched.")
