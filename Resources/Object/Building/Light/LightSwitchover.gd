@tool
extends StaticBody3D
class_name LightScene

@export var lit : bool = true:
	set(state):
		lit = state
		lit_setter(self)
@onready var on: Node3D = $On
@onready var off: Node3D = $Off
	
func _ready() -> void:
	lit_setter(self)
	
func lit_setter(obj:LightScene) -> void:
	if is_instance_valid(obj.on):
		obj.on.visible = obj.lit
		
func switch(value : bool) -> void:
	lit = value
