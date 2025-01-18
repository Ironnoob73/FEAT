extends MultiMeshInstance3D

## @tutorial(From): https://forum.godotengine.org/t/how-to-keep-surface-material-override-didnt-change/59110 https://forum.godotengine.org/t/help-with-multimeshinstance3d/49546/5
@onready var grass = $Grass.mesh

func _ready():
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = 8
	multimesh.mesh = grass
	for i in multimesh.instance_count:
		multimesh.set_instance_transform(i, Transform3D(Basis(), Vector3( randfn(0,0.5), 0, randfn(0,0.5))))
