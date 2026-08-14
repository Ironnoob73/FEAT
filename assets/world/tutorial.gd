extends Node3D

var step : int = 0
var idle : bool = true

@onready var timer: Timer = $Timer
@onready var player0: LocalPlayer = $Player

func _on_timer_timeout() -> void:
	if idle :	match step :
		0 :	move_mouse()
		2 :	parkour()
		3 :	open_door()
		4 :	pick_item()
		5 :	melee()
		6 :	range_w()
		7 :	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and step == 0:	step = 1
func _process(_delta: float) -> void:
	if step == 1 and player0.position.x != 0 and player0.position.z != 0 :	step = 2
	if step == 4 and player0.inventory.get_tool("weapon_TutorialSword") :	step = 5
func _on_parkour_waypoint_touch() -> void:
	if step == 2 : step = 3
func _on_door_plate_interact_signal(_i: AHL_Interactive,_s: Node) -> void:
	if step == 3 : step = 4
func _on_tutorial_sword_item_touch_signal() -> void:
	if step == 4 : step = 5
func _on_target_scene_killed_signal(_interactor: Variant, _sender: Variant) -> void:
	if step == 5 : step = 6

func move_mouse() -> void:
	idle = false
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var _c_tween: CallbackTweener = tween.tween_callback(func() -> void:player0.add_caption("tutorial.move_mouse.0"))
	_c_tween = tween.tween_callback(func() -> void:player0.add_caption("tutorial.move_mouse.1")).set_delay(5)
	var _p_tween: PropertyTweener = tween.tween_property(self, "idle", true, 0).set_delay(5)
func parkour() -> void:
	idle = false
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_column: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	var _c_tween: CallbackTweener = tween.tween_callback(func() -> void:player0.add_caption("tutorial.parkour.0"))
	_c_tween = tween.tween_callback(func() -> void:player0.add_caption("tutorial.parkour.1")).set_delay(5)
	var _p_tween: PropertyTweener = tween_column.tween_property($MovingBarrier, "position:z", -25, 3)
	_p_tween = tween_column.tween_property($Parkour/Column0, "position:y", 0.5, 0.5)
	_p_tween = tween_column.tween_property($Parkour/Column1, "position:y", 1, 1)
	_p_tween = tween_column.tween_property($Parkour/Column2, "position:y", 1.5, 1.5)
	_p_tween = tween_column.tween_property($Parkour/Column3, "position:y", 2, 2)
	_p_tween = tween_column.tween_property($Parkour/Column4, "position:y", 2.5, 2.5)
	_p_tween = tween_column.tween_property($Parkour/Column5, "position:y", 2.5, 3)
	_p_tween = tween.tween_property(self, "idle", true, 0).set_delay(5)
func open_door() -> void:
	idle = false
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_door: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	var _c_tween: CallbackTweener = tween.tween_callback(func() -> void:player0.add_caption("tutorial.opendoor.0"))
	var _p_tween: PropertyTweener = tween_door.tween_property($MovingBarrier, "position:z", -35, 2)
	_p_tween = tween_door.tween_property($OpenDoor/Wall, "position:y", 5, 2)
	_p_tween = tween_door.tween_property($OpenDoor/DoorPlate, "position:y", 0, 2)
	_p_tween = tween.tween_property(self, "idle", true, 0).set_delay(5)
func pick_item() -> void:
	idle = false
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_booth: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	var _c_tween: CallbackTweener = tween.tween_callback(func() -> void:player0.add_caption("tutorial.pick_item.0"))
	_c_tween = tween.tween_callback(func() -> void:player0.add_caption("tutorial.pick_item.1")).set_delay(5)
	_c_tween = tween.tween_callback(func() -> void:player0.add_caption("tutorial.pick_item.2")).set_delay(5)
	var _p_tween: PropertyTweener = tween_booth.tween_property($MovingBarrier, "position:z", -45, 2)
	_p_tween = tween_booth.tween_property($PickItem/Booth, "position:y", 0.5, 1)
	_p_tween = tween.tween_property(self, "idle", true, 0).set_delay(5)
func melee() -> void:
	idle = false
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_target: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	var _c_tween: CallbackTweener = tween.tween_callback(func() -> void:player0.add_caption("tutorial.melee.0"))
	_c_tween = tween.tween_callback(func() -> void:player0.add_caption("tutorial.melee.1")).set_delay(5)
	var _p_tween: PropertyTweener = tween_target.tween_property($MovingBarrier, "position:z", -50, 2)
	if $Melee/TargetScene != null:
		_p_tween = tween_target.tween_property($Melee/TargetScene, "position:y", 1, 1)
	_p_tween = tween.tween_property(self, "idle", true, 0).set_delay(5)
func range_w() -> void:
	idle = false
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_target: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	var _c_tween: CallbackTweener = tween.tween_callback(func() -> void:player0.add_caption("tutorial.range.0"))
	_c_tween = tween.tween_callback(func() -> void:player0.add_caption("tutorial.range.1")).set_delay(5)
	var _p_tween: PropertyTweener = tween_target.tween_property($PickSlingshot/Booth, "position:y", 0.5, 1)
	_p_tween = tween_target.tween_property($MovingBarrier, "position:z", -55, 2)
	if $Range/TargetScene != null:
		_p_tween = tween_target.tween_property($Range/TargetScene, "position:y", 1, 1)
	_p_tween = tween.tween_property(self, "idle", true, 0).set_delay(5)
