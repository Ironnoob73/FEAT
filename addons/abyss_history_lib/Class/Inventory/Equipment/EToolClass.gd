extends AHL_EquipmentClass
class_name AHL_EToolClass
## 可以手持的装备类。[br]
## Equipment class that can be held in hand.

@export_enum("undefined","wrench","special","heavy","light","shot","charge") var tool_type : String = "undefined"
@export var scene : PackedScene
@export var hitbox : Vector3 = Vector3(0.25,0.25,1)
## 进行攻击时的动画
@export_enum("Light","DoubleHand","Aimable") var attack_type : String = "Light"
## 伤害的发送类型，可用的有 [code]None[/code] , [code]Melee[/code] , [code]Range[/code] 。
@export_enum("None","Melee","Range") var send_type : String = "Melee"
@export_group("Range Setting")
## 最大装弹量，设置为-1表示无限。
@export var ammo_total :int = 0
@export_group("", "")
## 伤害类型
@export_enum("Normal","Sharp") var damage_type : String = "Normal"
@export var the_script : GDScript

func get_subname():
	if name1 :	return name1
	else :	return "tool.type." + tool_type
