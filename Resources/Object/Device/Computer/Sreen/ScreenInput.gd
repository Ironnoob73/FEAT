extends MeshInstance3D

@onready var viewport: SubViewport = $ScreenViewport

@onready var computer_screen: Control = $ScreenViewport/ComputerScreen
@onready var camera_3d: Camera3D = $"../CameraPose/Camera3D"

func _ready() -> void:
	var ready_pos : InputEventMouseMotion = InputEventMouseMotion.new()
	ready_pos.position = Vector2(viewport.size) / 2
	viewport.push_input(ready_pos)
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera_3d, "fov", 75, 5).set_delay(2)
	tween.tween_callback(func():Global.THE_PLAYER.remove_meta("lock_hud_hidden"))
	tween.tween_callback(func():Global.THE_PLAYER.remove_meta("lock_menu"))

func when_captured() -> void:
	get_parent().get_viewport().warp_mouse(viewport.get_mouse_position() / Vector2(viewport.size) * Vector2(get_parent().get_viewport().get_window().size))

func _input(event: InputEvent) -> void:
	if event is InputEventMouse and get_parent() is AHL_Interactive and get_parent().user != null and get_parent().user is LocalPlayer:
		var mouse_pos = get_parent().get_viewport().get_mouse_position() / Vector2(get_parent().get_viewport().get_window().size)
		event.position = mouse_pos * Vector2(viewport.size)
		viewport.push_input(event)
		
func _process(_delta: float) -> void:
	if computer_screen.desktop.visible:
		computer_screen.cursor.position = viewport.get_mouse_position()
		var mouse_pos = get_parent().get_viewport().get_mouse_position() / Vector2(get_parent().get_viewport().get_window().size)
		%CameraPose.rotation.y = lerp(%CameraPose.rotation.y, - (mouse_pos.x - 0.5) * 0.1, 0.01)
		%CameraPose.rotation.x = lerp(%CameraPose.rotation.x, - (mouse_pos.y - 0.5) * 0.1, 0.01)
	
