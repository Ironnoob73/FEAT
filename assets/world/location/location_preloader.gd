class_name LocationList

var ZhuShan: String = "res://assets/world/location/_zhu_shan/_scenes_package.tscn"
var Apartment0: String = "res://assets/world/location/_home/reality/_scene_package.tscn"
var DreamApartment: String = "res://assets/world/location/_home/dream/_scene_package.tscn"

var Cloud: String = "res://assets/world/location/9_cloud/_scenes_package.tscn"

static func _get_preloader() -> LocationList:
	return LocationList.new()

static func get_location_from_name(location_name:String) -> Resource:
	var path: String = _get_preloader().get(location_name)
	return load(path)

static func get_path_from_name(location_name:String) -> String:
	return _get_preloader().get(location_name)
