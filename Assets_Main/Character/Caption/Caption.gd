extends RichTextLabel

var num : int = 0

func _ready():
	modulate.a = 0
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate:a", 1, 0.5)
	

func update_pos():
	num += 1
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "position:y", 815 - num * 35, 0.5)
	if num == 5 :	_on_timer_timeout()

func _on_timer_timeout():
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_callback(self.queue_free)
