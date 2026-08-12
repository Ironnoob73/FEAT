extends AHL_BehaviorClass
class_name AHL_SitBehaviorClass
## 椅子行为，令交互者坐在自身指定位置。

func do(interactor: AHL_Interactive, sender: Node) -> void:
	if sender is LocalPlayer:
		var player_sender: LocalPlayer = sender
		if !interactor.has_meta("user"):
			player_sender.sit(interactor.global_position + Vector3(0,0,0), interactor.global_rotation)
			interactor.set_meta("user", sender)
			player_sender.isSit = interactor
		elif interactor.get_meta("user") == sender:
			interactor.remove_meta("user")
			player_sender._un_sit()
