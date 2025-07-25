extends Node

var ZhuShan = "res://Assets/World/Location/_ZhuShan/_ScenesPackage.tscn"
var Apartment0 = "res://Assets/World/Location/~Sandbox/Apartment0/ScenePackage.tscn"

func get_location_from_name(location_name:String):
	return load(get(location_name))

func get_path_from_name(location_name:String) -> String:
	return get(location_name)
