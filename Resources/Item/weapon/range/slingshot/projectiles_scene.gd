extends RigidBody3D
@onready var mesh: MeshInstance3D = $Mesh

@export var user : Node

#func _ready() -> void:
#	for i in self.get_colliding_bodies():
#		if i is player:
		
func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if self.linear_velocity.length() >= 1:
		if (body.get_parent() is AHL_Interactive and body.get_parent().Hurtable == true) or body is player:
			var damage_res = AHL_DamageResClass.new()
			damage_res.sender = user
			damage_res.damage_point = self.linear_velocity.length() / 25
			damage_res.attack_type = "normal"
			if body is not player:
				body.get_parent().receive_attack(damage_res,user)
			else:
				body.receive_attack(damage_res,user)
