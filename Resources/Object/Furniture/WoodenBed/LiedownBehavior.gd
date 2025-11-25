extends AHL_BehaviorClass
class_name LiedownBehavior

@export var can_sleep : bool = true

func do(interactor:Node,sender:Node) -> void:
	if sender is LocalPlayer:
		# Can't sleep when in dream world.
		var sleeping_count: Label = interactor.get_node("SleepingCount")
		if sender.isInDream:
			can_sleep = false
		var use_time : int = 3 if can_sleep else 1
		sender.current_menu = "Sleep"
		var tween = interactor.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
		tween.parallel().tween_property(sender, "position", interactor.position + Vector3(0,1.25,0), use_time)
		var target : float = interactor.rotation.y - deg_to_rad(180)
		if interactor.rotation.y - sender.rotation.y - deg_to_rad(180) < deg_to_rad(-180):
			target = interactor.rotation.y + deg_to_rad(180)
		tween.parallel().tween_property(sender, "rotation:y", target, use_time)
		tween.parallel().tween_property(sender, "rotation:x", deg_to_rad(90), use_time)
		sender.hide_hud(true)
		if can_sleep:
			tween.tween_callback(func():sleeping_count.show())
			tween.set_parallel().tween_property(sender.transition, "color:a", 1, 3).set_trans(Tween.TRANS_LINEAR)
			tween.tween_callback(func():sleeping_count.text = "💤3")
			tween.tween_callback(func():sleeping_count.text = "3").set_delay(0.5)
			tween.tween_callback(func():sleeping_count.text = "💤2").set_delay(1)
			tween.tween_callback(func():sleeping_count.text = "2").set_delay(1.5)
			tween.tween_callback(func():sleeping_count.text = "💤1").set_delay(2)
			tween.tween_callback(func():sleeping_count.text = "1").set_delay(2.5)
		
		# Get up
		var getup_func : Callable = func():
			tween.kill()
			sleeping_count.hide()
			sender.hide_hud(false)
			if can_sleep:
				var esc_tween = interactor.create_tween()
				esc_tween.tween_property(sender.transition, "color:a", 0, 0.1)
			sender.rotation.x = 0
			sender.disconnect("on_menu_change",interactor.get_meta("meta_getup_func"))
			interactor.remove_meta("meta_getup_func")
			
		# Put the get up function in meta data, it's a bit unorthodox.
		sender.connect("on_menu_change",getup_func)
		interactor.set_meta("meta_getup_func",getup_func)
