extends CSGCylinder3D

func _interact(_i: Node, sender: Player) -> void:
	Global.VRPos = sender.global_position
	Global.VRRot = sender.global_rotation
	Global.VRDim = get_node("/root/World").get_meta("Dim")
	
	var _loading_scene: AHL_LoadingScene =\
			AHL_LoadRequest.new_loader("res://Assets/World/Tutorial.tscn").replace_main().start_load()
