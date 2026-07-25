@tool
extends AHL_ScenePackage

@onready var corridor_scene: SubViewport = $CorridorScene
@onready var room_scene: SubViewport = $RoomScene

var mid_env: Environment = null

var first_elevator_level: int
var is_elevator_running: bool = false
@onready var first_elevator_level_text: Label3D = $CorridorScene/TheCorridor/ElevatorCorridorSolid/ElevatorControlPadScene/Body/Screen/LeftNumber
@onready var first_elevator_arrow: Label3D = $CorridorScene/TheCorridor/ElevatorCorridorSolid/ElevatorControlPadScene/Body/Screen/LeftArrow
@onready var first_arrow_running_anim: AnimationPlayer = $CorridorScene/TheCorridor/ElevatorCorridorSolid/ElevatorControlPadScene/Body/Screen/LeftArrow/LeftArrowRunningAnim
@onready var first_elevator_door: AHL_Interactive = $CorridorScene/TheCorridor/ElevatorCorridorSolid/FirstElevatorDoor
@onready var elevator_music: AudioStreamPlayer3D = $CorridorScene/TheCorridor/ElevatorMusic
@onready var elevator_view: MeshInstance3D = $CorridorScene/TheCorridor/ElevatorView
@onready var the_elevator: Node3D = $ElevatorScene/TheElevator

func _ready() -> void:
	super._ready()
	Global.current_world.real_time = false
	Global.current_world.player0.hide_hud(false)
	var esc_tween: Tween = create_tween()
	var _p_tween: PropertyTweener = null
	_p_tween = esc_tween.tween_property(Global.current_world.player0.transition, "color:a", 0, 0.1)
	Global.current_world.player0.rotation.x = 0
	Global.current_world.player0.current_menu = "HUD"
	
	room_connector.change_room.call_deferred(corridor_scene,room_scene)
	
	first_elevator_arrow.hide()
	first_elevator_level = randi_range(1, 9)
	first_elevator_level_text.text = str(first_elevator_level)
	var elevator_pos : int = - (5 - first_elevator_level) * 3
	the_elevator.position.y = elevator_pos
	elevator_view.position.y = elevator_pos
	elevator_music.position.y = elevator_pos + 3
 
func _switch_to_cloud(_interactor: Variant, _sender: Variant) -> void:
	Global.set_meta("wrap_from", "DreamApartment")
	AHL_LoadManager.load_scene(
			"res://Assets/World/Location/16_Cloud/_ScenesPackage.tscn",
			false, Vector3(0,0,0), false, Vector3(0,0,0), false
	)

func _move_elevator(interactor: TextedButton3d, sender: Variant) -> void:
	if first_elevator_level == 5:
		is_elevator_running = false
		first_arrow_running_anim.stop()
		first_elevator_arrow.show()
		first_elevator_arrow.text = interactor.text
		await interactor.timeout_unlit()
		first_elevator_door.switch(true, interactor)
	elif not (is_elevator_running and sender is LocalPlayer):
		is_elevator_running = true
		if sender is LocalPlayer:
			if not first_arrow_running_anim.is_playing():
				first_arrow_running_anim.play("running")
			var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel()
			var prop_time: float = abs(5 - first_elevator_level) * 1.5
			var _p_tween: PropertyTweener = null
			_p_tween = tween.tween_property(the_elevator, "position:y", 0, prop_time)
			_p_tween = tween.tween_property(elevator_view, "position:y", 0, prop_time)
			_p_tween = tween.tween_property(elevator_music, "position:y", 3, prop_time)
		first_elevator_arrow.text = "▼" if first_elevator_level > 5 else "▲"
		#first_elevator_arrow.show()
		await get_tree().create_timer(1.5,false,true,false).timeout
		first_elevator_level += 1 if first_elevator_level < 5 else -1
		first_elevator_level_text.text = str(first_elevator_level)
		await _move_elevator(interactor, self)
