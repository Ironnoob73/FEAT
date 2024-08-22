@tool
extends StaticBody3D

@export_enum("none","dark","light") var occlusion : String = "dark":
	set(state):
		occlusion = state
		OcclusionLogic.occlusion_setter(self)
@onready var occlusion_obj: MeshInstance3D = $Occlusion
@onready var occlusion_light_obj: MeshInstance3D = $Occlusion_light

func _ready() -> void:
	OcclusionLogic.occlusion_setter(self)
