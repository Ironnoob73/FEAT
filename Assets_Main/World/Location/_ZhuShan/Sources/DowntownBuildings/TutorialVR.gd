extends CSGCylinder3D

func _interact(_i, sender) -> void:
	Global.VRPos = sender.global_position
	Global.VRRot = sender.global_rotation
	Global.VRDim = get_node("/root/World").get_meta("Dim")
	LoadManager.load_scene("res://Assets_Main/World/Tutorial.tscn")
