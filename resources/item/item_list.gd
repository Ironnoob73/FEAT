class_name DefinedItemList

var weapon_TutorialSword: AHL_ThingClass = preload("res://resources/item/weapon/melee/sword/tutorial_sword.eq.tres")
var weapon_Tutorial_slingshot: AHL_ThingClass = preload("res://resources/item/weapon/range/slingshot/tutorial_slingshot.eq.tres")
var bullet_Tutorial_projectiles: AHL_ThingClass = preload("res://resources/item/consumables/bullet/basic_projectiles/tutorial_projectiles.tres")

static func _get_item_list() -> DefinedItemList:
	return DefinedItemList.new()

static func get_item_from_name(item_name:String) -> AHL_ThingClass:
	return _get_item_list().get(item_name)
	
static func get_tran_from_name(item_name:String) -> String:
	return _get_item_list().get(item_name).name0
static func get_icon_from_name(item_name:String) -> Texture2D:
	return _get_item_list().get(item_name).icon
