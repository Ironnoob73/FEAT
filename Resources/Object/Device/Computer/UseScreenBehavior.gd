extends AHL_BehaviorClass
class_name UseScreenBehavior

func do(interactor:Node,sender:Node) -> void:
	if sender is LocalPlayer:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		interactor.user = sender
		sender.current_menu = "Computer"
		sender.hide_hud(true)
		var camera_pos = interactor.get_node("%CameraPose")
		var camera : Camera3D = interactor.get_node("%CameraPose/Camera3D")
		camera.global_position = sender.player_camera.global_position
		camera.global_rotation = sender.player_camera.global_rotation
		camera.current = true
		var tween = interactor.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
		tween.tween_property(camera, "global_position",  camera_pos.global_position, 0.5)
		tween.tween_property(camera, "global_rotation",  MathUtil.smaller_rotate_3(camera.global_rotation,interactor.get_node("%CameraPose").global_rotation), 0.5)

		# Get up, copy from LayDownBehavior class for bed.
		var getup_func : Callable = func():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			tween.kill()
			sender.hide_hud(false)
			sender.lerp_camera(camera_pos.global_position, camera_pos.global_rotation)
			sender.disconnect("on_menu_change",interactor.get_meta("meta_getup_func"))
			interactor.force_leave()
			interactor.remove_meta("meta_getup_func")
			
		# Put the get up function in meta data, it's a bit unorthodox.
		sender.connect("on_menu_change",getup_func)
		interactor.set_meta("meta_getup_func",getup_func)
