extends AHL_BehaviorClass
class_name AHL_GenerateGoreBehaviorClass

func do(interactor,sender):
	for i in interactor.get_children():
		if i.name == "GorePreloader":
			for j in i.get_resource_list():
				var loaded_gore = i.get_resource(j).instantiate()
				interactor.get_parent().add_child(loaded_gore)
				loaded_gore.set_global_transform(interactor.get_global_transform())
				if self.has_meta("damage_res"):
					loaded_gore.receive_attack(self.get_meta("damage_res"))
