extends StaticBody3D

@export_multiline var comment : String

var interact_icon : String = "💬"

func interact(sender):
	sender.add_caption(comment)
