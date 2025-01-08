extends AHL_BehaviorClass
class_name AHL_SummonObjBehaviorClass
## 生成物体行为。

@export var object : PackedScene
@export var pos : Vector3 = Vector3(0,0,0)
@export var rot : Vector3 = Vector3(0,0,0)

func do(interactor,sender):
	var ins_obj = object.instantiate()
	interactor.add_child(ins_obj)
	ins_obj.position = pos
	ins_obj.rotation = Vector3(deg_to_rad(rot.x),deg_to_rad(rot.y),deg_to_rad(rot.z))
