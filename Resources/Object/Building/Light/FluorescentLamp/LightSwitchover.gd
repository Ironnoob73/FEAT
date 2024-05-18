extends StaticBody3D

@onready var _state_on = $On

func switch(value : bool):
	_state_on.visible = value
