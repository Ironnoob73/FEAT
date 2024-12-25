extends AHL_BehaviorClass
class_name AHL_ChangeColorBehaviorClass

@export var mesh_color : Color = Color(0,0,0,0)

func do(interactor,sender):
	if mesh_color:
		interactor.set_meta('c_color',mesh_color)
