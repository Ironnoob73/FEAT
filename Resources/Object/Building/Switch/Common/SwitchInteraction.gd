extends StaticBody3D

@export var state : bool
@export var connected_node : Array[NodePath]

@onready var _button = $Button

func _ready():
	_state_change()
func interact(_sender):
	state = !state
	_state_change()
	
	for i in connected_node :
		var Ni = get_node(i)
		if Ni.is_in_group("Switchable") :
			Ni.switch(state)
		else : push_warning("This connected node can't be switched.")
		
func _state_change():
	if state :	_button.rotation.x = deg_to_rad(10)
	else :		_button.rotation.x = deg_to_rad(-10)
