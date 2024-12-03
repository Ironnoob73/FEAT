extends Node

var weapon_TutorialSword = preload("res://Resources/Item/weapon/melee/sword/tutorial_sword.eq.tres")
var weapon_Tutorial_slingshot = preload("res://Resources/Item/weapon/range/slingshot/tutorial_slingshot.eq.tres")

func get_item_from_name(item_name:String):
	return get(item_name)
	
func get_tran_from_name(item_name:String):
	return get(item_name).name0
func get_icon_from_name(item_name:String):
	return get(item_name).icon
