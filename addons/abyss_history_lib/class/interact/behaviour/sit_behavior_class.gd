extends AHL_BehaviorClass
class_name AHL_SitBehaviorClass
## 椅子行为，令交互者坐在自身指定位置。

func do(interactor: AHL_Interactive, sender: Node) -> void:
	if sender is CharacterBody3D\
			and sender.has_method("get_is_sit")\
			and sender.has_method("sit")\
			and sender.has_method("un_sit"):
		var player_sender: CharacterBody3D = sender
		if !interactor.has_meta("user"):
			@warning_ignore("unsafe_method_access")
			player_sender.sit(interactor.global_position + Vector3(0,0,0), interactor.global_rotation)
			interactor.set_meta("user", sender)
			@warning_ignore("unsafe_property_access")
			player_sender.is_sit = interactor
		elif interactor.get_meta("user") == sender:
			interactor.remove_meta("user")
			@warning_ignore("unsafe_method_access")
			player_sender.un_sit()
