extends Area3D

func _ready() -> void:
	get_parent().hide()

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerMotion"):
		get_parent().visible = true

func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerMotion"):
		get_parent().visible = false
