extends TouchScreenButton
## @tutorial(Bilibili video tutorial refenrence): https://www.bilibili.com/video/BV16A4m1A7gA

var finger_index: int = -1
var drag_offset: Vector2
@onready var reset_pos: Vector2 = global_position
const DRAG_RADIUS: float = 16.0

func _input(event:InputEvent) -> void:
	if event is InputEventScreenTouch:
		var st: InputEventScreenTouch = event
		if st.pressed and finger_index == -1:
			var global_pos: Vector2 = st.position * get_canvas_transform()
			var local_pos: Vector2 = global_pos * get_canvas_transform()
			var rect: Rect2 = Rect2(Vector2.ZERO, texture_normal.get_size())
			if rect.has_point(local_pos):
				finger_index = st.index
				drag_offset = global_pos - global_position
		elif not st.pressed and st.index == finger_index:
			Input.action_release("ui_right")
			Input.action_release("ui_left")
			Input.action_release("ui_up")
			Input.action_release("ui_down")
			finger_index = -1
			global_position = reset_pos
			
	if event is InputEventScreenDrag:
		var sd: InputEventScreenDrag = event
		if sd.index == finger_index:
			var wish_pos: Vector2 = sd.position * get_canvas_transform() - drag_offset
			var movement: Vector2 = (wish_pos - reset_pos).limit_length(DRAG_RADIUS)
			global_position = reset_pos + movement
			
			movement /= DRAG_RADIUS
			if movement.x > 0:
				Input.action_release("ui_left")
				Input.action_press("ui_right",movement.x)
			elif movement.x < 0:
				Input.action_release("ui_right")
				Input.action_press("ui_left",-movement.x)
			if movement.y > 0:
				Input.action_release("ui_down")
				Input.action_press("ui_up",movement.y)
			elif movement.y < 0:
				Input.action_release("ui_up")
				Input.action_press("ui_down",-movement.y)
