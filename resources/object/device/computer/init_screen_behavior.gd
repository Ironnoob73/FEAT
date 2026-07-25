extends AHL_BehaviorClass
class_name InitScreenBehavoir

@export var screen_path: NodePath = NodePath()

func do(interactor:Node,_sender:Node) -> void:
	if screen_path != NodePath() and interactor.get_node(screen_path) is ComputerScreenContainer:
		var screen: ComputerScreenContainer = interactor.get_node(screen_path)
		screen.camera_pose = interactor.get_node("%CameraPose")
