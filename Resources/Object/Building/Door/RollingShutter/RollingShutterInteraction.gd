@tool
extends StaticBody3D

@export var open : bool = false:
	set(state):
		open = state
		if Engine.is_editor_hint():
			open_setter()
@export var inner : bool = false:
	set(state):
		inner = state
		inner_setter()
@export var lock : int = 0
@export_enum("none","dark","light") var occlusion : String = "dark":
	set(state):
		occlusion = state
		OcclusionLogic.occlusion_setter(self)
@export var ToLocation : String = "null"
@export var ToLocationPos : Vector3 = Vector3(0,1,0)

@onready var rolling_shutter_up: Node3D = $RollingShutterUp
@onready var p0: StaticBody3D = $DoorPlate0
@onready var p1: StaticBody3D = $DoorPlate1
@onready var p2: StaticBody3D = $DoorPlate2
@onready var lock_tip_f: Label3D = $LockTipF
@onready var lock_tip_b: Label3D = $LockTipB
@onready var occlusion_obj: MeshInstance3D = $Occlusion
@onready var occlusion_light_obj: MeshInstance3D = $Occlusion_light

func _ready() -> void:
	open_setter()
	inner_setter()
	OcclusionLogic.occlusion_setter(self)
		
func switch(value : bool) -> void:
	if open != value :
		var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(true)
		var _p_tween: PropertyTweener = null
		open = value
		if open :
			_p_tween = tween.tween_property(p0, "position:y", 2.8, 0.5)
			_p_tween = tween.tween_property(p1, "position:y", 2, 0.5)
			_p_tween = tween.tween_property(p2, "position:y", 1, 0.5)
			_p_tween = tween.tween_property(p1, "visible", false, 0).set_delay(0.5)
			_p_tween = tween.tween_property(p2, "visible", false, 0).set_delay(0.5)
			lock_tip_f.position.y = 2.5
			lock_tip_b.hide()
		else :
			_p_tween = tween.tween_property(p1, "visible", true, 0)
			_p_tween = tween.tween_property(p2, "visible", true, 0)
			_p_tween = tween.tween_property(p0, "position:y", 0, 0.5)
			_p_tween = tween.tween_property(p1, "position:y", 0, 0.5)
			_p_tween = tween.tween_property(p2, "position:y", 0, 0.5)
			lock_tip_f.position.y = 0.5
			lock_tip_b.show()

func show_locktip() -> void:
	var tween_f: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var _p_tween: PropertyTweener = null
	_p_tween = tween_f.tween_property(lock_tip_f, "modulate:a", 1, 0)
	_p_tween = tween_f.tween_property(lock_tip_f, "modulate:a", 0, 1)
	if !open :
		var tween_b: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		_p_tween = tween_b.tween_property(lock_tip_b, "modulate:a", 1, 0)
		_p_tween = tween_b.tween_property(lock_tip_b, "modulate:a", 0, 1)

func open_setter() -> void:
	if is_instance_valid(p0):
		if open :
			p0.position.y = 2.8
			p1.position.y = 2
			p2.position.y = 1
			p1.hide()
			p2.hide()
			lock_tip_f.position.y = 2.5
			lock_tip_b.hide()
		else:
			p0.position.y = 0
			p1.position.y = 0
			p2.position.y = 0
			p1.show()
			p2.show()
			lock_tip_f.position.y = 0.5
			lock_tip_b.show()

func inner_setter() -> void:
	if is_instance_valid(rolling_shutter_up):
		if inner:	rolling_shutter_up.hide()
		else:	rolling_shutter_up.show()
