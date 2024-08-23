@tool
extends StaticBody3D

@export var lit : bool = true:
	set(state):
		lit = state
		lit_setter(self)
@onready var on = $On
@onready var off = $Off
	
func _ready() -> void:
	lit_setter(self)
	
func lit_setter(obj:Node):
	if is_instance_valid(obj.on):
		obj.on.visible = obj.lit
		
func switch(value : bool):
	lit = value
