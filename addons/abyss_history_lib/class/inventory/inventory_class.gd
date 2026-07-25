extends Resource
class_name AHL_InventoryClass

signal on_items_changed
signal on_equipments_changed

@export var itemStack : Array[AHL_ItemStackClass]
@export var eqMeta : Array[AHL_EqMetaClass]

#Item
func add_item(item_name :String , count :int = 1 ):
	var item = AllItems.get_item_from_name(item_name)
	if item is AHL_ItemClass:
		var stacks = itemStack.filter(func(stack):return stack.item == item)
		if !stacks.is_empty():
			stacks[0].count += count
		else:
			var newStack = AHL_ItemStackClass.new()
			newStack.item = item
			newStack.count = count
			itemStack.append(newStack)
	elif item is AHL_EquipmentClass:
		add_equipment(item_name)
		push_warning("You're trying to add equipment using the Add Item function.")
	on_items_changed.emit()
	
func remove_item(item_name :String , count :int = 1 ):
	var item = AllItems.get_item_from_name(item_name)
	var stacks = itemStack.filter(func(stack):return stack.item == item)
	if !stacks.is_empty():
		if stacks[0].count >= count:
			stacks[0].count -= count
		else :	return "out"
		if stacks[0].count == 0:
			itemStack.erase(stacks[0])
	else :	return "off"
	on_items_changed.emit()

func sort_item(by_count:bool,direction:bool):
	if by_count :	itemStack.sort_custom(func(a, b): return (a.count < b.count)!=direction)
	else :	itemStack.sort_custom(func(a, b): return (a.item.name0 < b.item.name0)!=direction)
	on_items_changed.emit()

func get_item_count_from_en(item_name :String):
	var item = AllItems.get_item_from_name(item_name)
	var stacks = itemStack.filter(func(stack):return stack.item == item)
	if !stacks.is_empty() :	return stacks[0].count
	else :	return 0
func get_item_count_from_tr(item_name :String):
	var stacks = itemStack.filter(func(stack):return stack.item.name0 == item_name)
	if !stacks.is_empty() :	return stacks[0].count
	else :	return 0

#Equipment
func add_equipment(eq_name :String):
	var eq = AllItems.get_item_from_name(eq_name)
	if eq is AHL_EquipmentClass:
		var newEqMeta = AHL_EqMetaClass.new()
		newEqMeta.equipment = eq
		eqMeta.append(newEqMeta)
	on_equipments_changed.emit()
	
func remove_equipment(eq_name :String): # NEED TEST
	var eq = AllItems.get_item_from_name(eq_name)
	for i in eqMeta:
		if i.equipment == eq:
			eqMeta.erase(i)
			break
	on_equipments_changed.emit()
	
func sort_equipment(by_performance:bool,direction:bool):
	if by_performance :	eqMeta.sort_custom(func(a, b): return (a.equipment.performance < b.equipment.performance)!=direction)
	else :	eqMeta.sort_custom(func(a, b): return (a.equipment.name0 < b.equipment.name0)!=direction)
	on_equipments_changed.emit()

#Add instanced thing directly
func add_instance(thing : AHL_ThingInstanceClass):
	if thing:
		if thing is AHL_ItemStackClass :
			var stacks = itemStack.filter(func(stack):return stack.item == thing.item)
			if !stacks.is_empty():
				stacks[0].count += thing.count
			else:
				var newStack = AHL_ItemStackClass.new()
				newStack.item = thing.item
				newStack.count = thing.count
				itemStack.append(newStack)
		elif thing is AHL_EqMetaClass :
			eqMeta.append(thing)
		on_equipments_changed.emit()
