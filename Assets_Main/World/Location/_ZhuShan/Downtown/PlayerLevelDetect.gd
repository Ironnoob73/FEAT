extends Area3D

func _ready() -> void:
	get_parent().hide()
	get_parent().scale = Vector3(0,0,0)

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerMotion"):
		get_parent().visible = true
		get_parent().scale = Vector3(1,1,1)

func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerMotion"):
		get_parent().visible = false
		get_parent().scale = Vector3(0,0,0)
