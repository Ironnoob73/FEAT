extends Node3D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var right_hand_pos: Marker3D = $Body/Chest/ArmUR/ArmDR/RightHandPos
@onready var left_hand_pos: Marker3D = $Body/Chest/ArmUL/ArmDL/LeftHandPos

func _ready() -> void:
	change_visible(self)

func change_visible(node:Node):
	for i in node.get_children():
		if i is MeshInstance3D:
			i.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
		if i.get_child_count():
			change_visible(i)
