extends CSGCylinder3D

func _interact(_i: Node, sender: Player) -> void:
	Global.VRPos = sender.global_position
	Global.VRRot = sender.global_rotation
	Global.VRDim = get_node("/root/World").get_meta("Dim")
	AHL_LoadingScene.new_loader("res://Assets/World/Tutorial.tscn").start_load()
