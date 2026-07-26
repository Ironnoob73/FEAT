extends Control
class_name PlayerInventory

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var title: Label = $Panel_u/Title

@onready var item_list: Tree = $ItemInv/ItemList
@onready var item_name: Label = $ItemInv/Preview/Name
@onready var item_model: MeshInstance3D = $ItemInv/Preview/View/Viewport/MeshView2d/Mesh
@onready var item_description: RichTextLabel = $ItemInv/Preview/Description

@onready var equipment_list: Tree = $EquipmentInv/EquipmentList
@onready var equipment_name: Label = $EquipmentInv/Preview/Container/VBoxContainer/Name
@onready var equipment_subname: Label = $EquipmentInv/Preview/Container/VBoxContainer/Subname
@onready var equipment_info: Label = $EquipmentInv/Preview/Container/VBoxContainer/Info
@onready var equipment_model: MeshInstance3D = $EquipmentInv/Preview/View/Viewport/MeshView2d/Mesh
@onready var equipment_description: RichTextLabel = $EquipmentInv/Preview/Description
@onready var equipped_star: Texture2D = preload("res://resources/image/blue_star.svg")

@onready var hotbar: PanelContainer = $Hotbar
@onready var tool_hotbar: HBoxContainer = $Hotbar/VBox/ToolHBox
@onready var item_hotbar: HBoxContainer = $Hotbar/VBox/ItemHBox
@onready var hotbar_choose_window: ItemChooseWindow = $Hotbar/ItemChooseWindow
@onready var unequip_icon: Texture2D = preload("res://resources/image/ban.svg")
var current_hotbar_type : bool #false = tool , true = item
var current_hotbar_index : int

var current_inv: String = "Main"

signal mouse_mode_signal(mode: bool)

func init() -> void:
	item_list.set_column_expand_ratio(0,7)
	item_list.set_column_expand_ratio(1,1)
	equipment_list.set_column_expand_ratio(0,7)
	equipment_list.set_column_expand_ratio(1,1)
	item_inv_update()
	equipment_inv_update()
	var _connect: int = get_user().Inventory.on_items_changed.connect(item_inv_update)
	_connect = get_user().Inventory.on_equipments_changed.connect(equipment_inv_update)
	hotbar_button()

func hotbar_button() -> void:
	for child: Control in tool_hotbar.get_children():
		if child is Button :
			var c_button: Button = child
			var _connect: int = c_button.pressed.connect(func() -> void: choose_tool(c_button.get_index()))
	for child: Control in item_hotbar.get_children():
		if child is Button :
			var c_button: Button = child
			var _connect: int = c_button.pressed.connect(func() -> void:choose_item(c_button.get_index()))

func open_inventory() -> void:
	animation.play("Show")
func close_inventory() -> bool:
	title.text = "inventory.title"
	if !animation.is_playing():
		match current_inv:
			"Main" :
				animation.play_backwards("Show")
				get_user().current_menu = "HUD"
				mouse_mode_signal.emit(false)
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

func _on_back_button_pressed() -> void:
	var _bool: bool = close_inventory()
func _on_item_button_pressed() -> void:
	if current_inv == "Main":
		title.text = "inventory.item.t"
		animation.play("Item")
		current_inv = "Item"
	item_inv_update()
func _on_equipment_button_pressed() -> void:
	if current_inv == "Main":
		title.text = "inventory.equipment.t"
		animation.play("Equipment")
		current_inv = "Equipment"
	equipment_inv_update()
func _on_status_button_pressed() -> void:
	if current_inv == "Main":
		title.text = "inventory.status.t"
		animation.play("Status")
		current_inv = "Status"
	hotbar_refresh()

#Inventory
#Item
func item_inv_update() -> void:
	item_list.set_column_title(0,tr("list.name"))
	item_list.set_column_title(1,tr("list.count"))
	item_list.clear()
	var root: TreeItem = item_list.create_item()
	var item_group: TreeItem = item_list.create_item(root)
	item_group.set_text(0,tr("inventory.item.item"))
	var block_group: TreeItem = item_list.create_item(root)
	block_group.set_text(0,tr("inventory.item.block"))
	for i: AHL_ItemStackClass in get_user().Inventory.itemStack:
		var group: TreeItem
		#match i.item.get_original_class():
		#	"IBlockClass" :	group = block_group
		#	"ItemClass" :	group = item_group
		if i.item is AHL_IBlockClass :	group = block_group
		elif i.item is AHL_ItemClass :	group = item_group
		var subitem: TreeItem = item_list.create_item(group)
		subitem.set_icon(0, i.item.icon)
		subitem.set_icon_max_width(0,30)
		subitem.set_text(0,tr(i.item.name0))
		subitem.set_tooltip_text(0,tr(i.item.get_description()))
		#subitem.set_meta("DTooltip",i.item.get_description())
		subitem.set_text(1,str(i.count))
		subitem.set_text_alignment(1,HORIZONTAL_ALIGNMENT_RIGHT)
		subitem.set_metadata(0, get_user().Inventory.itemStack.find(i))
#View details
func _on_item_list_item_selected() -> void:
	var index: int = item_list.get_selected().get_metadata(0)
	if index != null:
		item_name.text = get_user().Inventory.itemStack[index].item.name0
		item_model.mesh = get_user().Inventory.itemStack[index].item.model
		if get_user().Inventory.itemStack[index].item.material:
			item_model.material_override = get_user().Inventory.itemStack[index].item.material
		item_description.text = get_user().Inventory.itemStack[index].item.get_description()
#Sort
func _on_item_list_column_title_clicked(column: int, mouse_button_index: int) -> void:
	get_user().Inventory.sort_item(bool(column), bool(mouse_button_index-1))

#Equipment
func equipment_inv_update() -> void:
	equipment_list.set_column_title(0,tr("list.name"))
	equipment_list.set_column_title(1,tr("list.performance"))
	equipment_list.clear()
	var root: TreeItem = equipment_list.create_item()
	var tool_group: TreeItem = equipment_list.create_item(root)
	tool_group.set_text(0,tr("inventory.equipment.tool"))
	var weapon_group: TreeItem = equipment_list.create_item(root)
	weapon_group.set_text(0,tr("inventory.equipment.weapon"))
	var armor_group: TreeItem = equipment_list.create_item(root)
	armor_group.set_text(0,tr("inventory.equipment.armor"))
	for i: AHL_EqMetaClass in get_user().Inventory.eqMeta:
		var group: TreeItem
		if i.equipment is AHL_EToolClass :
			var tool: AHL_EToolClass = i.equipment
			if tool.group == "weapon" :
				group = weapon_group
			else :
				group = tool_group
		var subitem: TreeItem = equipment_list.create_item(group)
		subitem.set_icon(0, i.equipment.icon)
		subitem.set_icon_max_width(0,30)
		subitem.set_text(0, tr(i.equipment.name0) + "   [" + str(int(((i.equipment.durability - i.damage)/i.equipment.durability)*100)) + "%]")
		subitem.set_tooltip_text(0, tr(i.equipment.get_subname()) + "\n" + str(i.equipment.durability - i.damage) + "/" + str(i.equipment.durability))
		#subitem.set_meta("DTooltip",i.equipment.get_subname() + "\n" + str(i.equipment.durability - i.damage) + "/" + str(i.equipment.durability))
		subitem.set_text(1,str(i.equipment.performance))
		subitem.set_text_alignment(1,HORIZONTAL_ALIGNMENT_RIGHT)
		subitem.set_metadata(0, get_user().Inventory.eqMeta.find(i))
#View details
func _on_equipment_list_item_selected() -> void:
	var index: int = equipment_list.get_selected().get_metadata(0)
	if index != null:
		equipment_name.text = get_user().Inventory.eqMeta[index].equipment.name0
		equipment_subname.text = get_user().Inventory.eqMeta[index].equipment.get_subname()
		equipment_info.text = \
			tr("list.performance") + ":" + str(get_user().Inventory.eqMeta[index].equipment.performance) + "\n" + \
			tr("equipment.durability") + ":" + \
			str(get_user().Inventory.eqMeta[index].equipment.durability - get_user().Inventory.eqMeta[index].damage) + "/" + str(get_user().Inventory.eqMeta[index].equipment.durability)
		equipment_model.mesh = get_user().Inventory.eqMeta[index].equipment.model
		if get_user().Inventory.eqMeta[index].equipment.material:
			equipment_model.material_override = get_user().Inventory.eqMeta[index].equipment.material
		equipment_description.text = get_user().Inventory.eqMeta[index].equipment.get_description()
#Sort
func _on_equipment_list_column_title_clicked(column: int, mouse_button_index: int) -> void:
	get_user().Inventory.sort_equipment(bool(column), bool(mouse_button_index-1))

#Hotbar
func hotbar_refresh() -> void:
	for child: Control in tool_hotbar.get_children():
		if child is Button :
			var c_button: Button = child
			if get_user().Inventory.ToolHotbar[c_button.get_index()]:
				var tool_info: AHL_EqMetaClass = get_user().Inventory.ToolHotbar[c_button.get_index()]
				c_button.icon = tool_info.equipment.icon
				#c_button.set_tooltip_text(\
				#	tr(tool_info.equipment.name0) + "\n" +\
				#	str(tool_info.equipment.durability - tool_info.damage) + "/" + str(tool_info.equipment.durability) + "\n" + \
				#	tr(tool_info.equipment.get_subname()) )
				c_button.set_meta("DTooltip",\
					tr(tool_info.equipment.name0) + "\n" +\
					str(tool_info.equipment.durability - tool_info.damage) + "/" + str(tool_info.equipment.durability) + "\n" + \
					tr(tool_info.equipment.get_subname()) )
			else:
				c_button.icon = null
				#child.set_tooltip_text("hotbar.empty")
				c_button.set_meta("DTooltip","hotbar.empty")
	for child: Control in item_hotbar.get_children():
		if child is Button :
			var c_button: Button = child
			if get_user().Inventory.ItemHotbar[c_button.get_index()]:
				var item_info: AHL_ItemClass = get_user().Inventory.ItemHotbar[c_button.get_index()]
				c_button.icon = item_info.icon
				#c_button.set_tooltip_text(\
				#	tr(item_info.name0) + "\n" +\
				#	str(get_parent().Inventory.get_item_count_from_tr(item_info.name0)) )
				c_button.set_meta("DTooltip",\
					tr(item_info.name0) + "\n" +\
					str(get_user().Inventory.get_item_count_from_tr(item_info.name0)) )
			else:
				c_button.icon = null
				#c_button.set_tooltip_text("hotbar.empty")
				c_button.set_meta("DTooltip","hotbar.empty")
func choose_tool(index:int) -> void:
	current_hotbar_type = false
	current_hotbar_index = index
	hotbar_choose_window.show()
	hotbar_choose_window.item_list.clear()
	var _int: int = hotbar_choose_window.item_list.add_item(tr("hotbar.unequip"),unequip_icon)
	for i: AHL_EqMetaClass in get_user().Inventory.eqMeta:
		if i.equipment is AHL_EToolClass :
			_int = hotbar_choose_window.item_list.add_item(\
				tr(i.equipment.name0) + "   [" + str(int(((i.equipment.durability - i.damage)/i.equipment.durability)*100)) + "%]" ,\
				i.equipment.icon)
			hotbar_choose_window.item_list.set_item_metadata(hotbar_choose_window.item_list.get_item_count()-1, get_user().Inventory.eqMeta.find(i))
func choose_item(index:int) -> void:
	current_hotbar_type = true
	current_hotbar_index = index
	hotbar_choose_window.show()
	hotbar_choose_window.item_list.clear()
	var _int: int = hotbar_choose_window.item_list.add_item(tr("hotbar.unequip"),unequip_icon)
	for i: AHL_ItemStackClass in get_user().Inventory.itemStack:
		if i.item is AHL_ItemClass :
			_int = hotbar_choose_window.item_list.add_item(\
				tr(i.item.name0) + "   [" + str(i.count) + "x]" ,\
				i.item.icon)
			hotbar_choose_window.item_list.set_item_metadata(hotbar_choose_window.item_list.get_item_count()-1,get_user().Inventory.itemStack.find(i))
#Set hotbar
func _on_item_choose_window_on_item_select(index: int) -> void:
	hotbar_choose_window.hide()
	if !current_hotbar_type:
		if get_user().Inventory.ToolHotbar[current_hotbar_index]:
			get_user().Inventory.eqMeta.append(get_user().Inventory.ToolHotbar[current_hotbar_index])
			get_user().Inventory.ToolHotbar[current_hotbar_index] = null
		if index != -1:
			get_user().Inventory.ToolHotbar[current_hotbar_index] = get_user().Inventory.eqMeta.pop_at(index)
	else:
		if index != -1 :	get_user().Inventory.ItemHotbar[current_hotbar_index] = get_user().Inventory.itemStack[index].item
		else :	get_user().Inventory.ItemHotbar[current_hotbar_index] = null
	hotbar_refresh()
	get_user().refresh_handheld(current_hotbar_index)
	
func get_user() -> LocalPlayer:
	return get_parent()
