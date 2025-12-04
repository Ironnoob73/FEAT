extends StaticBody3D

var nearly_player_list: Array[player]

func _ready() -> void:
	self.hide()
	var material0: ShaderMaterial = $Mesh.get_surface_override_material(0)
	$Mesh.set_surface_override_material(0,material0.duplicate(true))

func _process(_delta: float) -> void:
	if !nearly_player_list.is_empty():
		var nearest_length: float = 2
		self.show()
		for i in nearly_player_list:
			var distance = $Marker3D.global_position.distance_to(i.global_position)
			if distance < nearest_length:
				nearest_length = distance
			$Marker3D.global_position.y = i.global_position.y
		var material0: ShaderMaterial = $Mesh.get_surface_override_material(0)
		material0.set_shader_parameter("albedo",Color(1, 1, 1, min(1 - ((nearest_length - 1 )), 1) ))
	else:
		self.hide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	nearly_player_list.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	nearly_player_list.erase(body)
