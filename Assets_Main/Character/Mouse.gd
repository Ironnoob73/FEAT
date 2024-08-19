extends Control
@onready var cross_hair: TextureRect = $CrossHair

func get_mouse_pos() -> Vector2:
	cross_hair.position = get_global_mouse_position() - Vector2(4.5,4.5)
	return get_global_mouse_position() - get_size()/2
