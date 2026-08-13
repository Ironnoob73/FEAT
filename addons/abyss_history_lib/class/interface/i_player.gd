class_name IPlayer
extends GSInterface

static func of(obj: Object) -> IPlayer:
	return GSInterface.make_view(IPlayer, obj)

static func is_implemented_by(obj: Object) -> bool:
	return GSInterface.implements(obj, IPlayer)

func get_shoot_pos() -> Vector3:
	return _forward("get_shoot_pos")
	
func get_shoot_target_pos() -> Vector3:
	return _forward("get_shoot_target_pos")
