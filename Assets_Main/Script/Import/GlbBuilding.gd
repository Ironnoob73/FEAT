@tool #From : https://forum.godotengine.org/t/how-to-keep-surface-material-override-didnt-change/59110
extends EditorScenePostImport

func _post_import(scene):
	iterate(scene)
	return scene

func iterate(node):
	if node != null:
		if node is MeshInstance3D:
			# Override the materials of the mesh with a custom material
			var mesh:Mesh = node.mesh
			for i in mesh.get_surface_count():
				mesh.surface_set_material(i, load("res://Resources/Material/" + mesh.surface_get_material(i).resource_name + ".tres"))
			var collision = CollisionShape3D.new()
			collision.shape = ConcavePolygonShape3D.new()
			collision.shape.set_faces(mesh.get_faces())
			node.add_child(collision)
			node.set_cast_shadows_setting(2)
			print(node.get_cast_shadows_setting(),"cast shadow now")
			

		# Keep iterating
		for child in node.get_children():
			iterate(child)
