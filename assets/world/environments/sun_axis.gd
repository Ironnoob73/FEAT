extends Node3D
class_name sun_axis_class

@onready var sun_light: DirectionalLight3D = $SunLight
@onready var sun_visual: DirectionalLight3D = $SunVisual

var rotation_y: float = 0

func _process(_delta: float) -> void:
	sun_light.rotation.y = rotation_y
	sun_visual.rotation.y = rotation_y
