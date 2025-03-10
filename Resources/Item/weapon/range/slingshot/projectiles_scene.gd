extends RigidBody3D
@onready var mesh: MeshInstance3D = $Mesh
@export var user : Node

func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if (body.get_parent() is AHL_Interactive and body.get_parent().Hurtable == true and body.get_parent() != user)\
	or (body is player and body != user):
		var damage_res = AHL_DamageResClass.new()
		damage_res.sender = user
		damage_res.damage_point = self.linear_velocity.length() / 25
		damage_res.attack_type = "normal"
		if body is not player:
			body.get_parent().receive_attack(damage_res,user)
		else:
			body.receive_attack(damage_res,user)
		$Timer.start()

func _on_timer_timeout() -> void:
	self.queue_free()
