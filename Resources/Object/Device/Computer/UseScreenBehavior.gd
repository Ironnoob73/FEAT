extends AHL_BehaviorClass
class_name UseScreenBehavior

func do(interactor:Node,sender:Node) -> void:
	if sender is LocalPlayer:
		var player_sender: LocalPlayer = sender
		var comp_int: AHL_Interactive = interactor
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		comp_int.user = sender
		player_sender.current_menu = "Computer"
		player_sender.hide_hud(true)
		var camera_pos: Marker3D = comp_int.get_node("%CameraPose")
		var camera : Camera3D = interactor.get_node("%CameraPose/Camera3D")
		camera.global_position = player_sender.player_camera.global_position
		camera.global_rotation = player_sender.player_camera.global_rotation
		camera.current = true
		var tween: Tween = interactor.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
		var _p_tween: PropertyTweener = null
		_p_tween = tween.tween_property(camera, "global_position",  camera_pos.global_position, 0.5)
		_p_tween = tween.tween_property(camera, "global_rotation",  MathUtil.smaller_rotate_3(camera.global_rotation,camera_pos.global_rotation), 0.5)

		# Get up, copy from LayDownBehavior class for bed.
		var getup_func : Callable = func()->void:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			tween.kill()
			player_sender.hide_hud(false)
			player_sender.lerp_camera(camera_pos.global_position, camera_pos.global_rotation)
			var getup_call: Callable = comp_int.get_meta("meta_getup_func")
			player_sender.disconnect("on_menu_change",getup_call)
			comp_int.force_leave()
			comp_int.remove_meta("meta_getup_func")
			
		# Put the get up function in meta data, it's a bit unorthodox.
		var _err: Error = player_sender.connect("on_menu_change",getup_func)
		comp_int.set_meta("meta_getup_func",getup_func)
