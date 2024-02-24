extends Window

@onready var item_list = $Scroll/List
signal on_item_select(index:int)

func _on_close_requested():
	hide()

func _on_list_item_clicked(index, _at_position, _mouse_button_index):
	var item_index : int
	if item_list.get_item_metadata(index) is int:	
		item_index = item_list.get_item_metadata(index)
	else :	item_index = -1
	on_item_select.emit(item_index)
