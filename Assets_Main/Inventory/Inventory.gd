extends Control

@onready var animation = $AnimationPlayer
@onready var title = $Panel_u/Title

@onready var item_list = $ItemInv/ItemList
@onready var item_name = $ItemInv/Preview/Name
@onready var item_model = $ItemInv/Preview/View/Viewport/MeshView2d/Mesh
@onready var item_description = $ItemInv/Preview/Description

@onready var equipment_list = $EquipmentInv/EquipmentList
@onready var equipment_name = $EquipmentInv/Preview/Container/VBoxContainer/Name
@onready var equipment_subname = $EquipmentInv/Preview/Container/VBoxContainer/Subname
@onready var equipment_info = $EquipmentInv/Preview/Container/VBoxContainer/Info
@onready var equipment_model = $EquipmentInv/Preview/View/Viewport/MeshView2d/Mesh
@onready var equipment_description = $EquipmentInv/Preview/Description
@onready var equipped_star = preload("res://Resources/Image/blue_star.svg")

@onready var hotbar = $Hotbar
@onready var tool_hotbar = $Hotbar/VBox/ToolHBox
@onready var item_hotbar = $Hotbar/VBox/ItemHBox
@onready var hotbar_choose_window = $Hotbar/ItemChooseWindow
@onready var unequip_icon = preload("res://Resources/Image/ban.svg")
var current_hotbar_type : bool #false = tool , true = item
var current_hotbar_index : int

var current_inv = "Main"

func init():
	item_list.set_column_expand_ratio(0,7)
	item_list.set_column_expand_ratio(1,1)
	equipment_list.set_column_expand_ratio(0,7)
	equipment_list.set_column_expand_ratio(1,1)
	item_inv_update()
	equipment_inv_update()
	get_parent().Inventory.on_items_changed.connect(item_inv_update)
	get_parent().Inventory.on_equipments_changed.connect(equipment_inv_update)
	hotbar_button()

func hotbar_button():
	for child in tool_hotbar.get_children():
		if child is Button :
			child.pressed.connect(func():choose_tool(child.get_index()))
	for child in item_hotbar.get_children():
		if child is Button :
			child.pressed.connect(func():choose_item(child.get_index()))

func open_inventory():
	animation.play("Show")
func close_inventory():
	title.text = "inventory.title"
	if !animation.is_playing():
		match current_inv:
			"Main" :
				animation.play_backwards("Show")
				get_parent().current_menu = "HUD"
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			"Item" :
				current_inv = "Main"
				animation.play_backwards("Item")
			"Equipment" :
				current_inv = "Main"
				animation.play_backwards("Equipment")
			"Status" :
				current_inv = "Main"
				animation.play_backwards("Status")
		return true
	else :	return false

func _on_back_button_pressed():
	close_inventory()
func _on_item_button_pressed():
	if current_inv == "Main":
		title.text = "inventory.item.t"
		animation.play("Item")
		current_inv = "Item"
	item_inv_update()
func _on_equipment_button_pressed():
	if current_inv == "Main":
		title.text = "inventory.equipment.t"
		animation.play("Equipment")
		current_inv = "Equipment"
	equipment_inv_update()
func _on_status_button_pressed():
	if current_inv == "Main":
		title.text = "inventory.status.t"
		animation.play("Status")
		current_inv = "Status"
	hotbar_refresh()

#Inventory
#Item
func item_inv_update():
	item_list.set_column_title(0,tr("list.name"))
	item_list.set_column_title(1,tr("list.count"))
	item_list.clear()
	var root = item_list.create_item()
	var item_group = item_list.create_item(root)
	item_group.set_text(0,tr("inventory.item.item"))
	var block_group = item_list.create_item(root)
	block_group.set_text(0,tr("inventory.item.block"))
	for i in get_parent().Inventory.itemStack:
		var group : Object
		#match i.item.get_original_class():
		#	"IBlockClass" :	group = block_group
		#	"ItemClass" :	group = item_group
		if i.item is IBlockClass :	group = block_group
		elif i.item is ItemClass :	group = item_group
		var subitem = item_list.create_item(group)
		subitem.set_icon(0,i.item.icon)
		subitem.set_icon_max_width(0,30)
		subitem.set_text(0,tr(i.item.name0))
		subitem.set_tooltip_text(0,tr(i.item.get_description()))
		subitem.set_text(1,str(i.count))
		subitem.set_text_alignment(1,HORIZONTAL_ALIGNMENT_RIGHT)
		subitem.set_metadata(0,get_parent().Inventory.itemStack.find(i))
#View details
func _on_item_list_item_selected():
	var index = item_list.get_selected().get_metadata(0)
	if index != null:
		item_name.text = get_parent().Inventory.itemStack[index].item.name0
		item_model.mesh = get_parent().Inventory.itemStack[index].item.model
		if get_parent().Inventory.itemStack[index].item.material:
			item_model.material_override = get_parent().Inventory.itemStack[index].item.material
		item_description.text = get_parent().Inventory.itemStack[index].item.get_description()
#Sort
func _on_item_list_column_title_clicked(column, mouse_button_index):
	get_parent().Inventory.sort_item(bool(column),bool(mouse_button_index-1))

#Equipment
func equipment_inv_update():
	equipment_list.set_column_title(0,tr("list.name"))
	equipment_list.set_column_title(1,tr("list.performance"))
	equipment_list.clear()
	var root = equipment_list.create_item()
	var tool_group = equipment_list.create_item(root)
	tool_group.set_text(0,tr("inventory.equipment.tool"))
	var weapon_group = equipment_list.create_item(root)
	weapon_group.set_text(0,tr("inventory.equipment.weapon"))
	var armor_group = equipment_list.create_item(root)
	armor_group.set_text(0,tr("inventory.equipment.armor"))
	for i in get_parent().Inventory.eqMeta:
		var group : Object
		if i.equipment is EToolClass :	group = tool_group
		var subitem = equipment_list.create_item(group)
		subitem.set_icon(0,i.equipment.icon)
		subitem.set_icon_max_width(0,30)
		subitem.set_text(0,tr(i.equipment.name0) + "   [" + str(int(((i.equipment.durability - i.damage)/i.equipment.durability)*100)) + "%]")
		subitem.set_tooltip_text(0,tr(i.equipment.get_subname()) + "\n" + str(i.equipment.durability - i.damage) + "/" + str(i.equipment.durability))
		subitem.set_text(1,str(i.equipment.performance))
		subitem.set_text_alignment(1,HORIZONTAL_ALIGNMENT_RIGHT)
		subitem.set_metadata(0,get_parent().Inventory.eqMeta.find(i))
#View details
func _on_equipment_list_item_selected():
	var index = equipment_list.get_selected().get_metadata(0)
	if index != null:
		equipment_name.text = get_parent().Inventory.eqMeta[index].equipment.name0
		equipment_subname.text = get_parent().Inventory.eqMeta[index].equipment.get_subname()
		equipment_info.text = \
			tr("list.performance") + ":" + str(get_parent().Inventory.eqMeta[index].equipment.performance) + "\n" + \
			tr("equipment.durability") + ":" + \
			str(get_parent().Inventory.eqMeta[index].equipment.durability - get_parent().Inventory.eqMeta[index].damage) + "/" + str(get_parent().Inventory.eqMeta[index].equipment.durability)
		equipment_model.mesh = get_parent().Inventory.eqMeta[index].equipment.model
		if get_parent().Inventory.eqMeta[index].equipment.material:
			equipment_model.material_override = get_parent().Inventory.eqMeta[index].equipment.material
		equipment_description.text = get_parent().Inventory.eqMeta[index].equipment.get_description()
#Sort
func _on_equipment_list_column_title_clicked(column, mouse_button_index):
	get_parent().Inventory.sort_equipment(bool(column),bool(mouse_button_index-1))

#Hotbar
func hotbar_refresh():
	for child in tool_hotbar.get_children():
		if child is Button :
			if get_parent().Inventory.ToolHotbar[child.get_index()]:
				var tool_info = get_parent().Inventory.ToolHotbar[child.get_index()]
				child.icon = tool_info.equipment.icon
				child.set_tooltip_text(\
					tr(tool_info.equipment.name0) + "\n" +\
					str(tool_info.equipment.durability - tool_info.damage) + "/" + str(tool_info.equipment.durability) + "\n" + \
					tr(tool_info.equipment.get_subname()) )
			else:
				child.icon = null
				child.set_tooltip_text("hotbar.empty")
	for child in item_hotbar.get_children():
		if child is Button :
			if get_parent().Inventory.ItemHotbar[child.get_index()]:
				var item_info = get_parent().Inventory.ItemHotbar[child.get_index()]
				child.icon = item_info.icon
				child.set_tooltip_text(\
					tr(item_info.name0) + "\n" +\
					str(get_parent().Inventory.get_item_count_from_tr(item_info.name0)) )
			else:
				child.icon = null
				child.set_tooltip_text("hotbar.empty")
func choose_tool(index:int):
	current_hotbar_type = false
	current_hotbar_index = index
	hotbar_choose_window.show()
	hotbar_choose_window.item_list.clear()
	hotbar_choose_window.item_list.add_item(tr("hotbar.unequip"),unequip_icon)
	for i in get_parent().Inventory.eqMeta:
		if i.equipment is EToolClass :
			hotbar_choose_window.item_list.add_item(\
				tr(i.equipment.name0) + "   [" + str(int(((i.equipment.durability - i.damage)/i.equipment.durability)*100)) + "%]" ,\
				i.equipment.icon)
			hotbar_choose_window.item_list.set_item_metadata(hotbar_choose_window.item_list.get_item_count()-1,get_parent().Inventory.eqMeta.find(i))
func choose_item(index:int):
	current_hotbar_type = true
	current_hotbar_index = index
	hotbar_choose_window.show()
	hotbar_choose_window.item_list.clear()
	hotbar_choose_window.item_list.add_item(tr("hotbar.unequip"),unequip_icon)
	for i in get_parent().Inventory.itemStack:
		if i.item is ItemClass :
			hotbar_choose_window.item_list.add_item(\
				tr(i.item.name0) + "   [" + str(i.count) + "x]" ,\
				i.item.icon)
			hotbar_choose_window.item_list.set_item_metadata(hotbar_choose_window.item_list.get_item_count()-1,get_parent().Inventory.itemStack.find(i))
#Set hotbar
func _on_item_choose_window_on_item_select(index):
	hotbar_choose_window.hide()
	if !current_hotbar_type:
		if get_parent().Inventory.ToolHotbar[current_hotbar_index]:
			get_parent().Inventory.eqMeta.append(get_parent().Inventory.ToolHotbar[current_hotbar_index])
			get_parent().Inventory.ToolHotbar[current_hotbar_index] = null
		if index != -1:
			get_parent().Inventory.ToolHotbar[current_hotbar_index] = get_parent().Inventory.eqMeta.pop_at(index)
	else:
		if index != -1 :	get_parent().Inventory.ItemHotbar[current_hotbar_index] = get_parent().Inventory.itemStack[index].item
		else :	get_parent().Inventory.ItemHotbar[current_hotbar_index] = null
	hotbar_refresh()
	get_parent().refresh_handheld(current_hotbar_index)
	
