extends AHL_BehaviorClass
class_name AHL_RangeProjectilesBehaviorClass
## 根据交互者面朝方向发射射弹的行为。

@export var projectiles : PackedScene

func do(_interactor: AHL_Interactive, sender: Node) -> void:
	var ins_projectiles: Projectile3D = projectiles.instantiate()
	sender.get_parent().add_child(ins_projectiles)
	if sender is LocalPlayer:
		var player_sender: LocalPlayer = sender
		ins_projectiles.global_position = player_sender.facing.global_position
		# 玩家向量+发射向量
		ins_projectiles.linear_velocity = \
			player_sender.get_real_velocity() + \
			player_sender.facing.global_position.direction_to(player_sender.facing_target.global_position)*50 #未来需要根据武器定义
		ins_projectiles.rotation = player_sender.facing.global_rotation
		ins_projectiles.user = player_sender
