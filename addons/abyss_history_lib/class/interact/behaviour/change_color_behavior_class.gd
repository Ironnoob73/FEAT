extends AHL_BehaviorClass
class_name AHL_ChangeColorBehaviorClass
## 改变自身网格体颜色的行为。

@export var mesh_color : Color = Color(0,0,0,0)

func do(interactor:Node,sender:Node) -> void:
	if mesh_color:
		interactor.set_meta('c_color',mesh_color)
