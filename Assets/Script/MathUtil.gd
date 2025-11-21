class_name MathUtil

static func smaller_rotate(from:float,to:float) -> float:
	if to - from < deg_to_rad(-180):
		return to + deg_to_rad(360)
	elif to - from > deg_to_rad(180):
		return to - deg_to_rad(360)
	else:
		return to

static func smaller_rotate_3(from:Vector3,to:Vector3) -> Vector3:
	return Vector3(smaller_rotate(from.x,to.x),smaller_rotate(from.y,to.y),smaller_rotate(from.z,to.z))
