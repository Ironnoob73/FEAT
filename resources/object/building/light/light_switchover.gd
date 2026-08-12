@tool
class_name LightScene
extends AHL_Interactive

@onready var on: Node3D = $On
@onready var off: Node3D = $Off
		
func _ready() -> void:
	on.visible = state

func switch(value: bool, sender: Node) -> void:
	super.switch(value, sender)
	if is_instance_valid(on):
		on.visible = value
