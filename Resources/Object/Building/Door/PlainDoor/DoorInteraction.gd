@tool
extends StaticBody3D

var open : bool = false
@export var mesh_color : Color = Color(0,0,0,0):
	set(color):
		mesh_color = color
		if Engine.is_editor_hint():
			color_setter()
@export var mesh_material : Material = preload("res://Resources/Material/Wood.tres"):
	set(material):
		mesh_material = material
		if Engine.is_editor_hint():
			material_setter()
@export var lock : int = 0
signal interacted(bool)

@onready var mesh = $Hinge/Mesh
@onready var hinge = $Hinge
@onready var lock_tip_f = $Hinge/LockTipF
@onready var lock_tip_b = $Hinge/LockTipB

func _ready():
	if mesh_color != Color(0,0,0,0) :	MaterialUtil.recolor(mesh,mesh_color)
	if mesh_material : MaterialUtil.change_material(mesh,mesh_material)
	if lock : set_collision_layer_value(4,true)
	
func color_setter():
	MaterialUtil.recolor(mesh,mesh_color)
func material_setter():
	MaterialUtil.change_material(mesh,mesh_material)

func interact(_sender):
	if !open and lock:
		var tween_f = create_tween().set_trans(Tween.TRANS_LINEAR)
		var tween_b = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween_f.tween_property(lock_tip_f, "modulate:a", 1, 0)
		tween_b.tween_property(lock_tip_b, "modulate:a", 1, 0)
		tween_f.tween_property(lock_tip_f, "modulate:a", 0, 1)
		tween_b.tween_property(lock_tip_b, "modulate:a", 0, 1)
	#else:
	#	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	#	open = !open
	#	if open :	tween.tween_property(hinge, "rotation:y", deg_to_rad(90), 0.5)
	#	else :		tween.tween_property(hinge, "rotation:y", 0, 0.5)
	#	emit_signal("interacted",open)

func _on_auto_open_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerMotion") && !lock:
		open = true
		set_collision_layer_value(4,false)
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.tween_property(hinge, "rotation:y", deg_to_rad(90), 0.5)
func _on_auto_open_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerMotion") && !lock:
		open = false
		set_collision_layer_value(4,true)
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.tween_property(hinge, "rotation:y", 0, 0.5)
