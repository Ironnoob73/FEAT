@tool
extends StaticBody3D

@export var open : bool = false
@export var lock : int = 0

@onready var p0 = $DoorPlate0
@onready var p1 = $DoorPlate1
@onready var p2 = $DoorPlate2
@onready var lock_tip_f = $LockTipF
@onready var lock_tip_b = $LockTipB

func _ready():
	if open :
		p0.position.y = 3.5
		p1.position.y = 3.5
		p2.position.y = 3.3
		lock_tip_f.position.y = 2.5
		lock_tip_b.hide()
		
func switch(value : bool):
	if open != value :
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(true)
		open = value
		if open :
			tween.tween_property(p0, "position:y", 3.5, 0.5)
			tween.tween_property(p1, "position:y", 3.5, 0.5)
			tween.tween_property(p2, "position:y", 3.3, 0.5)
			lock_tip_f.position.y = 2.5
			lock_tip_b.hide()
		else :
			tween.tween_property(p2, "position:y", 0.5, 0.5)
			tween.tween_property(p1, "position:y", 1.5, 0.5)
			tween.tween_property(p0, "position:y", 2.5, 0.5)
			lock_tip_f.position.y = 0.5
			lock_tip_b.show()

func show_locktip():
	var tween_f = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween_f.tween_property(lock_tip_f, "modulate:a", 1, 0)
	tween_f.tween_property(lock_tip_f, "modulate:a", 0, 1)
	if !open :
		var tween_b = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween_b.tween_property(lock_tip_b, "modulate:a", 1, 0)
		tween_b.tween_property(lock_tip_b, "modulate:a", 0, 1)
