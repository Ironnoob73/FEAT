@tool
extends StaticBody3D

@export var open : bool = false:
	set(state):
		open = state
		if Engine.is_editor_hint():
			open_setter()
@export_enum("none","dark","light") var occlusion : String = "dark":
	set(state):
		occlusion = state
		occlusion_setter()
		
@onready var window_obj: AnimatableBody3D = $Window
@onready var occlusion_obj: MeshInstance3D = $Occlusion
@onready var occlusion_light_obj: MeshInstance3D = $Occlusion_light

func _ready() -> void:
	if open:	window_obj.rotation.y = deg_to_rad(90)
	occlusion_setter()
			
func open_setter():
	if open:	window_obj.rotation.y = deg_to_rad(90)
	else :	window_obj.rotation.y = 0
func occlusion_setter():
	if is_instance_valid(occlusion_obj) && is_instance_valid(occlusion_light_obj) :
		match occlusion:
			"none" :
				occlusion_obj.hide()
				occlusion_light_obj.hide()
			"dark" :
				occlusion_obj.show()
				occlusion_light_obj.hide()
			"light" :
				occlusion_light_obj.show()
				occlusion_obj.hide()
		
func interact(_sender):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	open = !open
	if open :	tween.tween_property(window_obj, "rotation:y", deg_to_rad(90), 0.5)
	else :		tween.tween_property(window_obj, "rotation:y", 0, 0.5)
