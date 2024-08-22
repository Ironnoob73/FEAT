extends StaticBody3D

@onready var lock_tip_f = $"../LockTipF"
@onready var lock_tip_b = $"../LockTipB"

func interact(_sender):
	if !get_parent().lock :
		get_parent().switch(!get_parent().open)
	else :
		get_parent().show_locktip()
