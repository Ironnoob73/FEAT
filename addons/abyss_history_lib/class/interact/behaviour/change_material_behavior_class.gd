extends AHL_BehaviorClass
class_name AHL_ChangeMaterialBehaviorClass
## 改变自身网格体材质的行为。

@export var mesh_material : Material

func do(interactor:Node,sender:Node) -> void:
	if mesh_material:
		interactor.set_meta('c_material',mesh_material)
