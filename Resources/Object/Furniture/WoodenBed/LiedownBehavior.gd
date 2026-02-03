extends AHL_BehaviorClass
class_name LiedownBehavior

@export var can_sleep : bool = true

func do(interactor:Node,sender:Node) -> void:
	if sender is LocalPlayer:
		var bed_int: AHL_Interactive = interactor
		var player_sender: LocalPlayer = sender
		# Can't sleep when in dream world.
		var sleeping_count: Label = bed_int.get_node("SleepingCount")
		if player_sender.isInDream:
			can_sleep = false
		var use_time : int = 3 if can_sleep else 1
		player_sender.current_menu = "Sleep"
		var tween: Tween = bed_int.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
		var _p_tween: PropertyTweener = null
		var _c_tween: CallbackTweener = null
		_p_tween = tween.parallel().tween_property(player_sender, "position", bed_int.global_position + Vector3(0,1.25,0), use_time)
		var target : float = bed_int.rotation.y - deg_to_rad(180)
		if bed_int.rotation.y - player_sender.rotation.y - deg_to_rad(180) < deg_to_rad(-180):
			target = bed_int.rotation.y + deg_to_rad(180)
		_p_tween = tween.parallel().tween_property(player_sender, "rotation:y", target, use_time)
		_p_tween = tween.parallel().tween_property(player_sender, "rotation:x", deg_to_rad(90), use_time)
		player_sender.hide_hud(true)
		if can_sleep:
			_c_tween = tween.tween_callback(func()->void:sleeping_count.show())
			_p_tween = tween.tween_property(sleeping_count, "modulate:a", 1, 0)
			_p_tween = tween.set_parallel().tween_property(player_sender.transition, "color:a", 1, 3).set_trans(Tween.TRANS_LINEAR)
			_c_tween = tween.tween_callback(func()->void:sleeping_count.text = "💤3")
			_c_tween = tween.tween_callback(func()->void:sleeping_count.text = "3").set_delay(0.5)
			_c_tween = tween.tween_callback(func()->void:sleeping_count.text = "💤2").set_delay(1)
			_c_tween = tween.tween_callback(func()->void:sleeping_count.text = "2").set_delay(1.5)
			_c_tween = tween.tween_callback(func()->void:sleeping_count.text = "💤1").set_delay(2)
			_c_tween = tween.tween_callback(func()->void:sleeping_count.text = "1").set_delay(2.5)
			_c_tween = tween.tween_callback(func()->void:sleeping_count.text = "💤0").set_delay(3)
			_p_tween = tween.tween_property(sleeping_count, "modulate:a", 0, 0.25).set_delay(3)
			_c_tween = tween.tween_callback(func()->void:
				AHL_LoadManager.load_scene(LocationPreload.get_path_from_name("DreamApartment"),
					true, Vector3(11,0,15), true, Vector3(0,deg_to_rad(180),0), false)
				var getup_call: Callable = bed_int.get_meta("meta_getup_func")
				player_sender.disconnect("on_menu_change",getup_call)
				player_sender.isInDream = true
					).set_delay(3.25)
		# Get up
		var getup_func : Callable = func()->void:
			tween.kill()
			sleeping_count.hide()
			player_sender.hide_hud(false)
			if can_sleep:
				var esc_tween: Tween = bed_int.create_tween()
				var _ep_tween: PropertyTweener = esc_tween.tween_property(player_sender.transition, "color:a", 0, 0.1)
			player_sender.rotation.x = 0
			var getup_call: Callable = bed_int.get_meta("meta_getup_func")
			player_sender.disconnect("on_menu_change",getup_call)
			bed_int.remove_meta("meta_getup_func")
			
		# Put the get up function in meta data, it's a bit unorthodox.
		var _err: Error = player_sender.connect("on_menu_change",getup_func)
		bed_int.set_meta("meta_getup_func",getup_func)
