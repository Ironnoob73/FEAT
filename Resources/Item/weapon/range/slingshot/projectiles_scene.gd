extends RigidBody3D
@onready var mesh: MeshInstance3D = $Mesh

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if linear_velocity.length() >= 0.1 and linear_velocity.cross(Vector3(0,1,0)) != Vector3(0,0,0):
		mesh.look_at(self.position + linear_velocity)
