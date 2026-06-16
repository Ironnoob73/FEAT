extends Node

var ZhuShan: String = "res://Assets/World/Location/_ZhuShan/_ScenesPackage.tscn"
var Apartment0: String = "res://Assets/World/Location/_Home/Reality/ScenePackage.tscn"
var DreamApartment: String = "res://Assets/World/Location/_Home/Dream/ScenePackage.tscn"

var Cloud: String = "res://Assets/World/Location/16_Cloud/_ScenesPackage.tscn"

func get_location_from_name(location_name:String) -> Resource:
	var path: String = get(location_name)
	return load(path)

func get_path_from_name(location_name:String) -> String:
	return get(location_name)
