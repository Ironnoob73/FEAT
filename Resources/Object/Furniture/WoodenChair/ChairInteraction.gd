extends StaticBody3D

func interact(sender):
	sender.sit( self.global_position + Vector3(0,0.7,0), self.global_rotation)
