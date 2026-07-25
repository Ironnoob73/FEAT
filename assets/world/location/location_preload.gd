extends Node

var ZhuShan: String = "res://assets/world/location/_zhu_shan/_scenes_package.tscn"
var Apartment0: String = "res://assets/world/location/_home/reality/_scene_package.tscn"
var DreamApartment: String = "res://assets/world/location/_home/dream/_scene_package.tscn"

var Cloud: String = "res://assets/world/location/9_cloud/_scenes_package.tscn"

func get_location_from_name(location_name:String) -> Resource:
	var path: String = get(location_name)
	return load(path)

func get_path_from_name(location_name:String) -> String:
	return get(location_name)
