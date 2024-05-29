extends AnimatableBody3D

@onready var mesh = $Mesh
@export var mesh_color : Color = Color(0,0,0,0)
@export var mesh_material : Material
@export var lock : int = 0
var open : bool = false
signal interacted(bool)

@onready var lock_tip_f = $LockTipF
@onready var lock_tip_b = $LockTipB

func _ready():
	if mesh_color != Color(0,0,0,0) :	MaterialUtil.recolor(mesh,mesh_color)
	if mesh_material : MaterialUtil.change_material(mesh,mesh_material)

func interact(_sender):
	if !open and lock:
		var tween_f = create_tween().set_trans(Tween.TRANS_LINEAR)
		var tween_b = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween_f.tween_property(lock_tip_f, "modulate:a", 1, 0)
		tween_b.tween_property(lock_tip_b, "modulate:a", 1, 0)
		tween_f.tween_property(lock_tip_f, "modulate:a", 0, 1)
		tween_b.tween_property(lock_tip_b, "modulate:a", 0, 1)
	else:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		open = !open
		if open :	tween.tween_property(self, "rotation:y", deg_to_rad(90), 0.5)
		else :		tween.tween_property(self, "rotation:y", 0, 0.5)
		emit_signal("interacted",open)
