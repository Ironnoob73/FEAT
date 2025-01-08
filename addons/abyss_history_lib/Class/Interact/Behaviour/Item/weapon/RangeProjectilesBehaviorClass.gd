extends AHL_BehaviorClass
class_name AHL_RangeProjectilesBehaviorClass
## 根据交互者面朝方向发射射弹的行为。

@export var projectiles : PackedScene

func do(interactor,sender):
	var ins_projectiles = projectiles.instantiate()
	sender.get_parent().add_child(ins_projectiles)
	ins_projectiles.global_position = sender.Facing.global_position
	ins_projectiles.linear_velocity = sender.Facing.global_position.direction_to(sender.FacingTarget.global_position)
