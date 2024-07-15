extends InventoryClass
class_name CInventoryClass

@export var ToolHotbar : Array[EqMetaClass]
@export var ItemHotbar : Array[ItemClass]

func get_tool(eq_name :String):
	var eq = AllItems.get_item_from_name(eq_name)
	var result : int = 0
	for i in ToolHotbar.size():
		if ToolHotbar[i] != null and ToolHotbar[i].equipment == eq :
			result = i + 1
	return result
