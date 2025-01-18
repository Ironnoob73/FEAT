extends Node3D

var step : int = 0
var idle : bool = true

@onready var timer = $Timer
@onready var player0 = $Player

func _on_timer_timeout():
	if idle :	match step :
		0 :	move_mouse()
		2 :	parkour()
		3 :	open_door()
		4 :	pick_item()
		5 :	melee()
		6 :	range_w()
		7 :	pass
	
func _input(event):
	if event is InputEventMouseMotion and step == 0:	step = 1
func _process(_delta):
	if step == 1 and player0.position.x != 0 and player.position.z != 0 :	step = 2
	if step == 4 and player0.Inventory.get_tool("weapon_TutorialSword") :	step = 5
func _on_parkour_waypoint_touch():
	if step == 2 : step = 3
func _on_door_plate_interact_signal(_i,_s) -> void:
	if step == 3 : step = 4
func _on_tutorial_sword_item_touch_signal() -> void:
	if step == 4 : step = 5
func _on_target_scene_killed_signal(_interactor: Variant, _sender: Variant) -> void:
	if step == 5 : step = 6

func move_mouse():
	idle = false
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func():player0.add_caption("tutorial.move_mouse.0"))
	tween.tween_callback(func():player0.add_caption("tutorial.move_mouse.1")).set_delay(5)
	tween.tween_property(self, "idle", true, 0).set_delay(5)
func parkour():
	idle = false
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_column = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_callback(func():player0.add_caption("tutorial.parkour.0"))
	tween.tween_callback(func():player0.add_caption("tutorial.parkour.1")).set_delay(5)
	tween_column.tween_property($MovingBarrier, "position:z", -25, 3)
	tween_column.tween_property($Parkour/Column0, "position:y", 0.5, 0.5)
	tween_column.tween_property($Parkour/Column1, "position:y", 1, 1)
	tween_column.tween_property($Parkour/Column2, "position:y", 1.5, 1.5)
	tween_column.tween_property($Parkour/Column3, "position:y", 2, 2)
	tween_column.tween_property($Parkour/Column4, "position:y", 2.5, 2.5)
	tween_column.tween_property($Parkour/Column5, "position:y", 2.5, 3)
	tween.tween_property(self, "idle", true, 0).set_delay(5)
func open_door():
	idle = false
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_door = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_callback(func():player0.add_caption("tutorial.opendoor.0"))
	tween_door.tween_property($MovingBarrier, "position:z", -35, 2)
	tween_door.tween_property($OpenDoor/Wall, "position:y", 5, 2)
	tween_door.tween_property($OpenDoor/DoorPlate, "position:y", 0, 2)
	tween.tween_property(self, "idle", true, 0).set_delay(5)
func pick_item():
	idle = false
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_booth = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_callback(func():player0.add_caption("tutorial.pick_item.0"))
	tween.tween_callback(func():player0.add_caption("tutorial.pick_item.1")).set_delay(5)
	tween.tween_callback(func():player0.add_caption("tutorial.pick_item.2")).set_delay(5)
	tween_booth.tween_property($MovingBarrier, "position:z", -45, 2)
	tween_booth.tween_property($PickItem/Booth, "position:y", 0.5, 1)
	tween.tween_property(self, "idle", true, 0).set_delay(5)
func melee():
	idle = false
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_target = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_callback(func():player0.add_caption("tutorial.melee.0"))
	tween.tween_callback(func():player0.add_caption("tutorial.melee.1")).set_delay(5)
	tween_target.tween_property($MovingBarrier, "position:z", -50, 2)
	if $Melee/TargetScene != null:
		tween_target.tween_property($Melee/TargetScene, "position:y", 1, 1)
	tween.tween_property(self, "idle", true, 0).set_delay(5)
func range_w():
	idle = false
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_target = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_callback(func():player0.add_caption("tutorial.range.0"))
	tween.tween_callback(func():player0.add_caption("tutorial.range.1")).set_delay(5)
	tween_target.tween_property($PickSlingshot/Booth, "position:y", 0.5, 1)
	tween_target.tween_property($MovingBarrier, "position:z", -55, 2)
	if $Range/TargetScene != null:
		tween_target.tween_property($Range/TargetScene, "position:y", 1, 1)
	tween.tween_property(self, "idle", true, 0).set_delay(5)
