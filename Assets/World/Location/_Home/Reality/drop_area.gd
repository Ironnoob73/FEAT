extends Area3D

var player0: LocalPlayer = null
var current_pos: Vector3 = Vector3(0,0,0)
var current_vel: float = 0

func _on_body_entered(body: Node3D) -> void:
	if body is LocalPlayer:
		player0 = body
		current_pos = body.global_position
		current_vel = abs(body.velocity.y) * 0.01
		
		body.hide_hud(true)
		body.set_meta("lock_hud_hidden",true)
		
func _process(_delta: float) -> void:
	if player0:
		current_vel = lerpf(current_vel, 0.005, 0.05)
		current_pos.y -= current_vel
		player0.position = current_pos
