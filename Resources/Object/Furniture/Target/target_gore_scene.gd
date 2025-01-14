extends Node3D

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	self.queue_free()

func receive_final_attack(damage_res:AHL_DamageResClass):
	for i in self.get_children():
		i.set_linear_velocity(	(damage_res.sender.global_position\
								+Vector3(0,damage_res.sender.player_collision.shape.height * 0.5,0))\
								.direction_to(i.global_position)*damage_res.damage_point*randf())
