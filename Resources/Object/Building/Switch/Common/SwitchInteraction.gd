extends StaticBody3D

@onready var _button = $Button

func _ready():
	_state_change()

func _interact_signal(_i,_s) -> void:
	if is_node_ready():
		_state_change()
		
func _state_change():
	if get_parent().state :	_button.rotation.x = deg_to_rad(10)
	else :		_button.rotation.x = deg_to_rad(-10)
