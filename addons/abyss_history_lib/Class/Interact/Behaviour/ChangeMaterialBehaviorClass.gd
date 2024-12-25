extends AHL_BehaviorClass
class_name AHL_ChangeMaterialBehaviorClass

@export var mesh_material : Material

func do(interactor,sender):
	if mesh_material:
		interactor.set_meta('c_material',mesh_material)
