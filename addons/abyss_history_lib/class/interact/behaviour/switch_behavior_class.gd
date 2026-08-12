extends AHL_BehaviorClass
class_name AHL_SwitchBehaviorClass
## 开关行为，交互时同时调整连接到自身的节点。

@export var connected_node : Array[NodePath]
@export_enum("Interact", "Reversal", "On", "Off", "Sync", "AntiSync") var switch_to : String = "Interact"

func do(interactor: AHL_Interactive, sender: Node) -> void:
	for i: NodePath in connected_node :
		var Ni: Node = interactor.get_node(i)
		if Ni is AHL_Interactive:
			var INi: AHL_Interactive = Ni
			if INi.Switchable:
				match switch_to:
					"Reversal": INi.switch(!interactor.state, interactor)
					"On": INi.switch(true, interactor)
					"Off": INi.switch(false, interactor)
					"Sync":
						if interactor is AHL_Interactive:
							var int_sender: AHL_Interactive = interactor
							INi.switch(int_sender.state, int_sender)
						else:
							push_error(sender, "is not Interactive.")
					"AntiSync":
						if interactor is AHL_Interactive:
							var int_sender: AHL_Interactive = interactor
							INi.switch(!int_sender.state, int_sender)
						else:
							push_error(sender, "is not Interactive.")
					"Interact", _:
						INi.interact(interactor)
		else :
			push_warning("This connected node can't be switched.")
