extends CSGBox3D

func interact(_sender):
	if !get_parent().lock :
		get_parent().switch(!get_parent().open)
	else :
		print("ERR_LOCKED")
