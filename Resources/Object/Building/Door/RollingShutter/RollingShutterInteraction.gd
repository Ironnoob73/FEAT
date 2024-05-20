extends StaticBody3D

@export var open : bool = false

@onready var p0 = $DoorPlate0
@onready var p1 = $DoorPlate1
@onready var p2 = $DoorPlate2

func switch(value : bool):
	if open != value :
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(true)
		open = value
		if open :
			tween.tween_property(p0, "position:y", 3.5, 0.5)
			tween.tween_property(p1, "position:y", 3.5, 0.5)
			tween.tween_property(p2, "position:y", 3.3, 0.5)
		else :
			tween.tween_property(p2, "position:y", 0.5, 0.5)
			tween.tween_property(p1, "position:y", 1.5, 0.5)
			tween.tween_property(p0, "position:y", 2.5, 0.5)
