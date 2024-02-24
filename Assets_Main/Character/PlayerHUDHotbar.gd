extends Control

@onready var tool_name = $HotBar/HotbatInfo/FreeName/Name
@onready var tool_icon = $HotBar/IconBackground/Margin/Icon
@onready var tool_durability = $HotBar/HotbatInfo/Durability

@onready var hotbar_slot = $CurrentSlot

func set_info(i_slot:int ,i_name:String = "" ,i_icon:Texture = null ,i_durability:float = 0.0):
	tool_name.text = i_name
	tool_icon.texture = i_icon
	tool_durability.value = i_durability
	hotbar_slot.text = str(i_slot + 1)
