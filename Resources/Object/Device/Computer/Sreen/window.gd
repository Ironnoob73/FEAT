extends Panel

## @tutorial(From): https://github.com/popcar2/GodotOS/blob/main/Scenes/Window/window.gd

@onready var icon: TextureRect = $VBox/HBox/Icon
@onready var title: Label = $VBox/HBox/Title

var is_focus: bool
var is_dragging: bool
var start_drag_position: Vector2
var mouse_start_drag_position: Vector2

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = start_drag_position + (get_global_mouse_position() - mouse_start_drag_position)
		#clamp_window_inside_viewport()
	if get_parent().get_child_count() - get_index() == 1:
		theme_type_variation = "WindowBackground"
	else:
		theme_type_variation = "WindowBackgroundUnf"

func _on_title_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			on_focus()
			is_dragging = true
			start_drag_position = global_position
			mouse_start_drag_position = get_global_mouse_position()
		else:
			is_dragging = false
			if position.y > 687:
				position.y = 687
			if position.y < 0:
				position.y = 0
			if position.x > 1049:
				position.x = 1049
			if position.x < 63 - size.x:
				position.x = 63 - size.x

func _on_window_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		on_focus()
	
func _on_close_button_pressed() -> void:
	queue_free()

func on_focus():
	get_parent().move_child(self,-1)
