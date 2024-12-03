extends Node3D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var right_hand_pos: Marker3D = $Body/Chest/ArmUR/ArmDR/RightHandPos
@onready var left_hand_pos: Marker3D = $Body/Chest/ArmUL/ArmDL/LeftHandPos

func change_visible(node:Node,vis:bool):
	for i in node.get_children():
		if i is MeshInstance3D:
			if vis:
				i.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
			else:
				i.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
		if i.get_child_count():
			change_visible(i,vis)
