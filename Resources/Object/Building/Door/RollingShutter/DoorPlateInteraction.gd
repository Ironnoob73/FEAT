extends CSGBox3D

func interact(_sender):
	get_parent().switch(!get_parent().open)
