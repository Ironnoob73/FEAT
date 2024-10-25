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
var lock = func () : return get_parent().get_meta('lock_int',0)

@onready var mesh = $Hinge/Mesh
@onready var hinge = $Hinge
@onready var lock_tip_f = $Hinge/LockTipF
@onready var lock_tip_b = $Hinge/LockTipB

func _ready():
	if get_c_color() != Color(0,0,0,0) :	MaterialUtil.recolor(mesh,get_c_color())
	#if mesh_color != Color(0,0,0,0) :	MaterialUtil.recolor(mesh,mesh_color)
	if get_c_material(): MaterialUtil.change_material(mesh,get_c_material())
	#if mesh_material : MaterialUtil.change_material(mesh,mesh_material)
	if !get_parent().is_node_ready():
		await get_parent().ready
		_state_change()
	
func color_setter():
	MaterialUtil.recolor(mesh,mesh_color)
func material_setter():
	MaterialUtil.change_material(mesh,mesh_material)

func interact(_sender):
	if !open and get_lock():
		var tween_f = create_tween().set_trans(Tween.TRANS_LINEAR)
		var tween_b = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween_f.tween_property(lock_tip_f, "modulate:a", 1, 0)
		tween_b.tween_property(lock_tip_b, "modulate:a", 1, 0)
		tween_f.tween_property(lock_tip_f, "modulate:a", 0, 1)
		tween_b.tween_property(lock_tip_b, "modulate:a", 0, 1)

func _interact_signal() -> void:
	if is_node_ready():
		_state_change()
		
func _on_auto_open_area_area_entered(area: Area3D) -> void:
	pass
	#if area.is_in_group("PlayerMotion") && !get_lock():
	#	open = true
	#	set_collision_layer_value(4,false)
	#	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	#	tween.tween_property(hinge, "rotation:y", deg_to_rad(90), 0.5)
func _on_auto_open_area_area_exited(area: Area3D) -> void:
	pass
	#if area.is_in_group("PlayerMotion"):
	#	open = false
	#	set_collision_layer_value(4,true)
	#	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	#	tween.tween_property(hinge, "rotation:y", 0, 0.5)

func get_lock() -> int:
	return get_parent().get_meta('lock_int',0)
func get_c_material() -> Material:
	return get_parent().get_meta('c_material',mesh_material)
func get_c_color() -> Color:
	return get_parent().get_meta('c_color',mesh_color)
	
func _state_change():
	if get_parent() is Interactive && !get_lock():
		if get_parent().state:
			get_parent().interact_text = "interact.close"
			open = true
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			tween.tween_property(self, "rotation:y", deg_to_rad(90), 0.5)
		else :
			get_parent().interact_text = "interact.open"
			open = false
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			tween.tween_property(self, "rotation:y", 0, 0.5)
