extends StaticBody3D

@onready var _button: MeshInstance3D = $Button

func _ready() -> void:
	_state_change()

func _interact_signal(_i:Variant,_s:Variant) -> void:
	if is_node_ready():
		_state_change()
		
func _state_change() -> void:
	var parent_n: AHL_Interactive = get_parent()
	if parent_n.state :	_button.rotation.x = deg_to_rad(10)
	else :		_button.rotation.x = deg_to_rad(-10)
