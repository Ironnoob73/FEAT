class_name Caption
extends RichTextLabel

var num : int = 0

func _ready() -> void:
	modulate.a = 0
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var _p_tween: PropertyTweener= tween.tween_property(self, "modulate:a", 1, 0.5)
	

func update_pos() -> void:
	num += 1
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var _p_tween: PropertyTweener = tween.tween_property(self, "position:y", 815 - num * 35, 0.5)
	if num == 5 :	_on_timer_timeout()

func _on_timer_timeout() -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var _p_tween: PropertyTweener = tween.tween_property(self, "modulate:a", 0, 0.5)
	var _c_tween: CallbackTweener = tween.tween_callback(self.queue_free)
