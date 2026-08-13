extends AHL_BehaviorClass
class_name AHL_RangeProjectilesBehaviorClass
## 根据交互者面朝方向发射射弹的行为。

@export var projectiles : PackedScene

func do(_interactor: AHL_Interactive, sender: Node) -> void:
	var ins_projectiles: Projectile3D = projectiles.instantiate()
	sender.get_parent().add_child(ins_projectiles)
	if sender is CharacterBody3D and IPlayer.is_implemented_by(sender):
		var player_sender: CharacterBody3D = sender
		var player_interface: IPlayer = IPlayer.of(player_sender)
		ins_projectiles.global_position = player_interface.get_shoot_pos()
		# 玩家向量+发射向量
		ins_projectiles.linear_velocity = \
			player_sender.get_real_velocity() + \
			player_interface.get_shoot_pos().direction_to(player_interface.get_shoot_target_pos())*50 #未来需要根据武器定义
		ins_projectiles.rotation = player_interface.get_shoot_pos()
		ins_projectiles.user = player_sender
