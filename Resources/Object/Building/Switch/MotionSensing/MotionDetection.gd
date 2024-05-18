extends Area3D

@export var state : bool
@export var connected_node : Array[NodePath]

var detected_player : Node = null

@onready var timer = $Timer
	
func _physics_process(_delta):
	if detected_player :
		if !detected_player.isCrouch and \
		detected_player.velocity.distance_squared_to(Vector3(0,0,0)) >= 10.0**-6 :
			state = true
			_switch()
			timer.start()

func _on_timer_timeout():
	state = false
	_switch()
	
func _switch():
	for i in connected_node :
		var Ni = get_node(i)
		if Ni.is_in_group("Switchable") :
			Ni.switch(state)
		else : push_warning("This connected node can't be switched.")
