class_name ItemChooseWindow
extends Popup

@onready var item_list: ItemList = $Scroll/List
signal on_item_select(index:int)

func _on_close_requested() -> void:
	hide()

func _on_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var item_index : int
	if item_list.get_item_metadata(index) is int:	
		item_index = item_list.get_item_metadata(index)
	else :	item_index = -1
	on_item_select.emit(item_index)
