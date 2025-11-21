extends MeshInstance3D

@onready var viewport: SubViewport = $ScreenViewport

@onready var computer_screen: TextureRect = $ScreenViewport/ComputerScreen
@onready var cursor: Sprite2D = $ScreenViewport/ComputerScreen/Cursor

func _ready() -> void:
	var ready_pos : InputEventMouseMotion = InputEventMouseMotion.new()
	ready_pos.position = Vector2(viewport.size) / 2
	viewport.push_input(ready_pos)

func when_captured() -> void:
	get_parent().get_viewport().warp_mouse(viewport.get_mouse_position() / Vector2(viewport.size) * Vector2(get_parent().get_viewport().get_window().size))

func _input(event: InputEvent) -> void:
	if event is InputEventMouse and get_parent() is AHL_Interactive and get_parent().user != null and get_parent().user is LocalPlayer:
		event.position = get_parent().get_viewport().get_mouse_position() / Vector2(get_parent().get_viewport().get_window().size) * Vector2(viewport.size)
		viewport.push_input(event)
		
func _process(_delta: float) -> void:
	cursor.position = viewport.get_mouse_position()
	
