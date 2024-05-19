extends AnimatableBody3D

@onready var mesh = $Mesh
@export var mesh_color : Color = Color(0,0,0,0)
@export var mesh_material : Material
var open : bool = false

func _ready():
	if mesh_color != Color(0,0,0,0) :	MaterialUtil.recolor(mesh,mesh_color)
	if mesh_material : MaterialUtil.change_material(mesh,mesh_material)

func interact(_sender):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	open = !open
	if open :	tween.tween_property(self, "rotation:y", deg_to_rad(90), 0.5)
	else :		tween.tween_property(self, "rotation:y", 0, 0.5)
