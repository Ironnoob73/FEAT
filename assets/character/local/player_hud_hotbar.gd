class_name HudHotBar
extends Control

@onready var tool_name: Label = $HotBar/HotbatInfo/FreeName/Name
@onready var tool_icon: TextureRect = $HotBar/IconBackground/Margin/Icon
@onready var tool_durability: ProgressBar = $HotBar/HotbatInfo/Durability

@onready var hotbar_slot: Label = $CurrentSlot

@onready var ammo: PanelContainer = $AmmoBg
@onready var ammo_num: Label = $AmmoBg/Ammo/AmmoInfo/Label
@onready var ammo_pb: ProgressBar = $AmmoBg/Ammo/AmmoInfo/ProgressBar
@onready var ammo_inf: Control = $AmmoBg/Ammo/Inf

func _ready() -> void:
	set_ammo_info()

func set_info(i_slot:int , i_name:String = "" , i_icon:Texture = null , i_durability:float = 0.0) -> void:
	tool_name.text = i_name
	tool_icon.texture = i_icon
	tool_durability.value = i_durability
	hotbar_slot.text = str(i_slot + 1)

func set_ammo_info(isShow:bool = false, ammo_total:int = 0, ammo_left:int = 0) -> void:
	ammo_inf.visible = (ammo_total == -1)
	ammo_num.text = str(ammo_left) + "/" + str(ammo_total) if (ammo_total != -1) else "       "
	ammo_pb.value = float(ammo_left) / float(ammo_total) if (ammo_total != -1) else 1.0
	ammo.visible = isShow
