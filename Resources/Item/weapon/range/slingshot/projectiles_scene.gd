extends RigidBody3D
@onready var mesh: MeshInstance3D = $Mesh
@onready var timer: Timer = $Timer
@export var user: Node

func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	var interactive_obj: AHL_Interactive = null
	if body.get_parent() is AHL_Interactive:
		interactive_obj = body.get_parent()
	if (interactive_obj and interactive_obj.Hurtable == true and interactive_obj.get_parent() != user)\
	or (body is player and body != user):
		var damage_res: AHL_DamageResClass = AHL_DamageResClass.new()
		damage_res.sender = user
		damage_res.damage_point = self.linear_velocity.length() / 25
		damage_res.attack_type = "normal"
		if body is not player:
			interactive_obj.receive_attack(damage_res,user)
		else:
			var player_th: player = body
			player_th.receive_attack(damage_res,user)
		timer.start()

func _on_timer_timeout() -> void:
	self.queue_free()
