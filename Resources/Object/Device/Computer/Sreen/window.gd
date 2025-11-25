extends Panel

## @tutorial(From): https://github.com/popcar2/GodotOS/blob/main/Scenes/Window/window.gd

@onready var icon: TextureRect = $VBox/HBox/Icon
@onready var title: Label = $VBox/HBox/Title

var is_dragging: bool
var start_drag_position: Vector2
var mouse_start_drag_position: Vector2

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = start_drag_position + (get_global_mouse_position() - mouse_start_drag_position)
		#clamp_window_inside_viewport()

func _on_title_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			on_focus()
			is_dragging = true
			start_drag_position = global_position
			mouse_start_drag_position = get_global_mouse_position()
		else:
			is_dragging = false

func _on_close_button_pressed() -> void:
	queue_free()

func on_focus():
	get_parent().move_child(self,-1)
