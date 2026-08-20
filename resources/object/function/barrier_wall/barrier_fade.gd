extends StaticBody3D

var nearly_player_list: Array[Player]

@onready var mesh: MeshInstance3D = $Mesh
@onready var marker: Marker3D = $Marker3D

func _ready() -> void:
	self.hide()
	var material0: ShaderMaterial = mesh.get_surface_override_material(0).duplicate(true)
	mesh.set_surface_override_material(0, material0)

func _process(_delta: float) -> void:
	if !nearly_player_list.is_empty():
		var nearest_length: float = 2
		self.show()
		for i: Player in nearly_player_list:
			var distance: float = marker.global_position.distance_to(i.global_position)
			if distance < nearest_length:
				nearest_length = distance
			marker.global_position.y = i.global_position.y
		var material0: ShaderMaterial = mesh.get_surface_override_material(0)
		var min_length: float = min(2 - nearest_length, 1)
		material0.set_shader_parameter("albedo", Color(1, 1, 1, min_length))
	else:
		self.hide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	nearly_player_list.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	nearly_player_list.erase(body)
