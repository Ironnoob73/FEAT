@tool
extends AHL_ScenePackage

signal elevator_run()

var first_elevator_level: int
var is_elevator_running: bool = false:
	set(state):
		is_elevator_running = state
		if !state:
			elevator_run.emit()

@onready var corridor_scene: SubViewport = $CorridorScene
@onready var room_scene: SubViewport = $RoomScene
@onready var elevator_scene: SubRoomViewport = $ElevatorScene

@onready var up_button: TextedButton3d = $CorridorScene/TheCorridor/ElevatorCorridorSolid/ElevatorControlPadScene/UpButton
@onready var down_button: TextedButton3d = $CorridorScene/TheCorridor/ElevatorCorridorSolid/ElevatorControlPadScene/DownButton

@onready var first_elevator_level_text: Label3D = $CorridorScene/TheCorridor/ElevatorCorridorSolid/ElevatorControlPadScene/Body/Screen/LeftNumber
@onready var first_elevator_arrow: Label3D = $CorridorScene/TheCorridor/ElevatorCorridorSolid/ElevatorControlPadScene/Body/Screen/LeftArrow
@onready var first_arrow_running_anim: AnimationPlayer = $CorridorScene/TheCorridor/ElevatorCorridorSolid/ElevatorControlPadScene/Body/Screen/LeftArrow/LeftArrowRunningAnim
@onready var first_elevator_door: AHL_Interactive = $CorridorScene/TheCorridor/ElevatorCorridorSolid/FirstElevatorDoor
@onready var elevator_music: AudioStreamPlayer3D = $CorridorScene/TheCorridor/ElevatorMusic
@onready var elevator_view: MeshInstance3D = $CorridorScene/TheCorridor/ElevatorView
@onready var the_elevator: Elevator = $ElevatorScene/TheElevator

func _ready() -> void:
	super._ready()
	Global.current_world.real_time = false
	Global.current_world.player0.hide_hud(false)
	var esc_tween: Tween = create_tween()
	var _p_tween: PropertyTweener = null
	_p_tween = esc_tween.tween_property(Global.current_world.player0.transition, "color:a", 0, 0.1)
	Global.current_world.player0.rotation.x = 0
	Global.current_world.player0.current_menu = "HUD"
	
	RoomConnector.change_room.call_deferred(corridor_scene, room_scene)
	
	first_elevator_arrow.hide()
	first_elevator_level = randi_range(1, 9)
	first_elevator_level_text.text = str(first_elevator_level)
	var elevator_pos : int = - (5 - first_elevator_level) * 3
	the_elevator.position.y = elevator_pos
	elevator_view.position.y = elevator_pos
	elevator_music.position.y = elevator_pos + 3
 
func move_elevator(interactor: TextedButton3d, sender: Variant, to_level: int) -> void:
	# 已位于或到达当前楼层
	if first_elevator_level == to_level:
		is_elevator_running = false
		first_arrow_running_anim.stop()
		first_elevator_arrow.show()
		# 来自电梯内部数字按钮的请求发送来的被交互者为null
		if interactor:
			if (interactor.text == "▲" or interactor.text == "▼"):
				first_elevator_arrow.text = interactor.text
			else:
				first_elevator_arrow.hide()
			await interactor.timeout_unlit()
		else:
			await get_tree().create_timer(1.5,false,true,false).timeout
		if to_level == 5:
			first_elevator_door.switch(true, interactor)
		var hide_timer: SceneTreeTimer = null
		if first_elevator_arrow.has_meta("stay_hide_timer"):
			hide_timer = first_elevator_arrow.get_meta("stay_hide_timer")
			hide_timer.time_left = 1.5
		else:
			hide_timer = get_tree().create_timer(1.5,false,true,false)
			first_elevator_arrow.set_meta("stay_hide_timer", hide_timer)
		if hide_timer:
			await hide_timer.timeout
			first_elevator_arrow.remove_meta("stay_hide_timer")
			first_elevator_arrow.hide()
	# 电梯即将运行和运行过程中，非当前层则将发送者改为自己与即将运行时区分。
	elif not (is_elevator_running and sender != self):
		is_elevator_running = true
		if sender != self:
			first_elevator_arrow.text = "▼" if first_elevator_level > to_level else "▲"
			first_elevator_arrow.show()
			# 如果由外部按钮请求，等待以模拟关门。
			if interactor and (interactor.text == "▲" or interactor.text == "▼"):
				await get_tree().create_timer(1.5,false,true,false).timeout
			if not first_arrow_running_anim.is_playing():
				first_arrow_running_anim.play("running")
			var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
			var _p_tween: PropertyTweener = null
			if elevator_scene.own_world_3d: # 玩家处于电梯内时，电梯场景不具有独立世界。
				var prop_time: float = abs(to_level - first_elevator_level) * 1.5 # 电梯需要经过楼层的时间
				_p_tween = tween.tween_property(the_elevator, "position:y", - (5 - to_level) * 3, prop_time)
				_p_tween = tween.tween_property(elevator_view, "position:y", - (5 - to_level) * 3, prop_time)
				_p_tween = tween.tween_property(elevator_music, "position:y", - (5 - to_level) * 3 + 3, prop_time)
			else:
				tween = tween.set_ease(Tween.EASE_IN) # 处于电梯内时只需移动一层
				_p_tween = tween.tween_property(the_elevator, "position:y", (-1 if to_level < 5 else 1) * 3, 1.5)
				match to_level:
					9:	await _switch_to_9_cloud()
		await get_tree().create_timer(1.5,false,true,false).timeout
		first_elevator_level += 1 if first_elevator_level < to_level else -1
		first_elevator_level_text.text = str(first_elevator_level)
		await move_elevator(interactor, self, to_level)

func _switch_to_9_cloud() -> void:
	Global.set_meta("wrap_from", "DreamApartment")
	var load_request: AHL_LoadRequest =\
			AHL_LoadRequest.new_loader("res://assets/world/location/9_cloud/_scenes_package.tscn")\
					.cover(false)
	var loading_scene: AHL_LoadingScene = load_request.start_load()
	await loading_scene.load_done
	Global.set_meta("elevator_music_process", the_elevator.music.get_playback_position())

func _move_elevator_to_current_level(interactor: TextedButton3d, sender: Variant) -> void:
	if is_elevator_running or (the_elevator.requested_level.size() and not the_elevator.elevator_door.is_closing):
		return
	elif the_elevator.elevator_door.is_closing:
		the_elevator.elevator_door.switch(true, interactor)
		await interactor.timeout_unlit()
	else:
		await move_elevator(interactor, sender, 5)

func _on_the_elevator_request_arrow(arrow: String) -> void:
	first_elevator_arrow.show()
	first_elevator_arrow.text = arrow

func _request_to_current_level_request() -> void:
	if up_button.state:
		await _move_elevator_to_current_level(up_button, up_button)
	if down_button.state:
		await _move_elevator_to_current_level(down_button, down_button)
