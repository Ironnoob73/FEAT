extends BehaviorClass
class_name GenerateGoreBehaviorClass

func do(interactor,sender):
	for i in interactor.get_children():
		if i.name == "GorePreloader":
			for j in i.get_resource_list():
				var loaded_gore = i.get_resource(j).instantiate()
				interactor.get_parent().add_child(loaded_gore)
				loaded_gore.global_position = interactor.global_position
