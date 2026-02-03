extends MeshInstance3D
class_name ComputerScreenContainer

@onready var viewport: SubViewport = $ScreenViewport

@onready var computer_screen: ComputerScreen = $ScreenViewport/ComputerScreen
@onready var camera_3d: Camera3D = $"../CameraPose/Camera3D"

@onready var camera_pose: Marker3D = null

func _ready() -> void:
	var ready_pos : InputEventMouseMotion = InputEventMouseMotion.new()
	ready_pos.position = Vector2(viewport.size) / 2
	viewport.push_input(ready_pos)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	if !Global.FastBoot or Global.oobe:
		camera_3d.fov = 61.5
		var _p_tween: PropertyTweener = tween.tween_property(camera_3d, "fov", 75, 5).set_delay(2)
	if get_parent().is_node_ready():
		camera_pose = get_parent().get_node("%CameraPos")

func when_captured() -> void:
	get_parent().get_viewport().warp_mouse(viewport.get_mouse_position() / Vector2(viewport.size) * Vector2(get_parent().get_viewport().get_window().size))

func _input(event: InputEvent) -> void:
	if get_parent() is AHL_Interactive:
		var parent_computer: AHL_Interactive = get_parent()
		if parent_computer.user != null and parent_computer.user is LocalPlayer:
			#@warning_ignore("untyped_declaration")
			#for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
			if event is InputEventMouseButton or event is InputEventMouseMotion or event is InputEventScreenDrag or event is InputEventScreenTouch:
				var mouse_pos: Vector2 = get_parent().get_viewport().get_mouse_position() / Vector2(get_parent().get_viewport().get_window().size)
				if event is InputEventMouse:
					var window_input_event: InputEventMouse = event
					window_input_event.position = mouse_pos * Vector2(viewport.size)
					viewport.push_input(window_input_event)
				elif event is InputEventScreenTouch:
					var screen_input_event: InputEventScreenTouch = event
					screen_input_event.position = mouse_pos * Vector2(viewport.size)
					viewport.push_input(screen_input_event)
				elif event is InputEventScreenDrag:
					var screen_input_event: InputEventScreenDrag = event
					screen_input_event.position = mouse_pos * Vector2(viewport.size)
					viewport.push_input(screen_input_event)
		
func _process(_delta: float) -> void:
	if camera_pose != null:
		if computer_screen.cursor.visible:
			computer_screen.cursor.position = viewport.get_mouse_position()
			var mouse_pos: Vector2 = get_parent().get_viewport().get_mouse_position() / Vector2(get_parent().get_viewport().get_window().size)
			camera_pose.rotation.y = lerp(camera_pose.rotation.y, - (mouse_pos.x - 0.5) * 0.1, 0.01)
			camera_pose.rotation.x = lerp(camera_pose.rotation.x, - (mouse_pos.y - 0.5) * 0.1, 0.01)
		else:
			camera_pose.rotation.y = lerp(camera_pose.rotation.y, 0.0, 0.01)
			camera_pose.rotation.x = lerp(camera_pose.rotation.x, 0.0, 0.01)
		
func _on_computer_screen_offing() -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var _p_tween: PropertyTweener = tween.tween_property(camera_3d, "fov", 61.5, 10)
