extends AHL_BehaviorClass
class_name AHL_RangeProjectilesBehaviorClass
## 根据交互者面朝方向发射射弹的行为。

@export var projectiles : PackedScene

func do(_interactor: AHL_Interactive, sender: Node) -> void:
	var ins_projectiles: Projectile3D = projectiles.instantiate()
	sender.get_parent().add_child(ins_projectiles)
	if sender is CharacterBody3D\
			and sender.has_method("get_shoot_pos")\
			and sender.has_method("get_shoot_target_pos"):
		var player_sender: CharacterBody3D = sender
		@warning_ignore("unsafe_method_access")
		ins_projectiles.global_position = player_sender.get_shoot_pos()
		# 玩家向量+发射向量
		@warning_ignore("unsafe_method_access")
		ins_projectiles.linear_velocity = \
			player_sender.get_real_velocity() + \
			player_sender.get_shoot_pos().direction_to(player_sender.get_shoot_target_pos())*50 #未来需要根据武器定义
		@warning_ignore("unsafe_method_access")
		ins_projectiles.rotation = player_sender.get_shoot_pos()
		ins_projectiles.user = player_sender
