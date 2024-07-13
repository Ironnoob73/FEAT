extends StaticBody3D

@export_multiline var comment : String

func interact(sender):
	sender.add_caption(comment)
