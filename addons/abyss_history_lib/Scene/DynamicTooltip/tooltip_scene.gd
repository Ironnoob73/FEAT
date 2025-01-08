extends Panel

@onready var text: RichTextLabel = $RichTextLabel

func _process(delta: float) -> void:
	self.position = get_viewport().get_mouse_position() + Vector2(10,10)
	if get_viewport().gui_get_hovered_control():
		text.text = get_viewport().gui_get_hovered_control().name
	if text.size != self.size:
		self.size = lerp(self.size, text.size, 0.5)
