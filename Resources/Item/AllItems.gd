extends Node

var weapon_TutorialSword: AHL_ThingClass = preload("res://Resources/Item/weapon/melee/sword/tutorial_sword.eq.tres")
var weapon_Tutorial_slingshot: AHL_ThingClass = preload("res://Resources/Item/weapon/range/slingshot/tutorial_slingshot.eq.tres")
var bullet_Tutorial_projectiles: AHL_ThingClass = preload("res://Resources/Item/consumables/bullet/basic_projectiles/tutorial_projectiles.tres")

func get_item_from_name(item_name:String) -> AHL_ThingClass:
	return get(item_name)
	
func get_tran_from_name(item_name:String) -> String:
	return get(item_name).name0
func get_icon_from_name(item_name:String) -> Texture2D:
	return get(item_name).icon
