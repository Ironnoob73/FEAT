extends InventoryClass
class_name CInventoryClass

@export var ToolHotbar : Array[EqMetaClass]
@export var ItemHotbar : Array[ItemClass]

func get_tool(eq_name :String):
	var eq = AllItems.get_item_from_name(eq_name)
	for i in ToolHotbar.size():
		if ToolHotbar[i] != null and ToolHotbar[i].equipment == eq :
			return i
	#var meta = ToolHotbar.filter(func(eqmeta):return eqmeta.equipment == eq)
	#if !meta.is_empty() :	return true
	#else :	return false
