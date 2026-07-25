@tool
extends EditorScenePostImport
## @tutorial(From): https://forum.godotengine.org/t/how-to-keep-surface-material-override-didnt-change/59110

func _post_import(scene: Node) -> Node:
	iterate(scene)
	return scene

func iterate(node: Node) -> void:
	if node != null:
		if node is MeshInstance3D:
			var instance: MeshInstance3D = node
			# Override the materials of the mesh with a custom material
			var mesh: Mesh = instance.mesh
			for i: int in mesh.get_surface_count():
				var mat_path: String = "res://resources/material/" + mesh.surface_get_material(i).resource_name.to_snake_case() + ".tres"
				if FileAccess.file_exists(mat_path):
					var mat: Material = load(mat_path)
					mesh.surface_set_material(i, mat)
			var collision: CollisionShape3D = CollisionShape3D.new()
			var shape: ConcavePolygonShape3D = ConcavePolygonShape3D.new()
			collision.shape = shape
			shape.set_faces(mesh.get_faces())
			instance.add_child(collision)
			instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED
			

		# Keep iterating
		for child: Node in node.get_children():
			iterate(child)
