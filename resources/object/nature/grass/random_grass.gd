extends MultiMeshInstance3D

## @tutorial(Godot forum post reference): https://forum.godotengine.org/t/help-with-multimeshinstance3d/49546/5
@onready var grass: MeshInstance3D = $Grass

func _ready() -> void:
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = 8
	multimesh.mesh = grass.mesh
	for i: int in multimesh.instance_count:
		multimesh.set_instance_transform(i, Transform3D(Basis(), Vector3( randfn(0,0.5), 0, randfn(0,0.5))))
