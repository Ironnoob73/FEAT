extends Node3D

var step : int = 0
var idle : bool = true

@onready var tip = $Tip
@onready var timer = $Timer
@onready var player = $Player

func _on_timer_timeout():
	if idle :	match step :
		0 :	move_mouse()
		3 :	parkour()
	
func _input(event):
	if event is InputEventMouseMotion and step == 1:	step = 2
	
func _process(_delta):
	if step == 2 and player.position.x != 0 and player.position.z != 0 :	step = 3
	
func move_mouse():
	idle = false
	step = 1
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(tip, "text", "tutorial.move_mouse.0",0)
	tween.tween_property(tip, "modulate:a", 1, 0.5)
	tween.tween_property(tip, "modulate:a", 0, 0.5).set_delay(5)
	tween.tween_property(tip, "text", "tutorial.move_mouse.1",0)
	tween.tween_property(tip, "modulate:a", 1, 0.5)
	tween.tween_property(tip, "modulate:a", 0, 0.5).set_delay(5)
	tween.tween_property(self, "idle", true, 0)
func parkour():
	idle = false
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween_column = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_property(tip, "text", "tutorial.parkour.0",0)
	tween.tween_property(tip, "modulate:a", 1, 0.5)
	tween.tween_property(tip, "modulate:a", 0, 0.5).set_delay(5)
	tween.tween_property(tip, "text", "tutorial.parkour.1",0)
	tween.tween_property(tip, "modulate:a", 1, 0.5)
	tween.tween_property(tip, "modulate:a", 0, 0.5).set_delay(5)
	tween_column.tween_property($MovingBarrier, "position:z", -22.5, 3)
	tween_column.tween_property($Parkour/Column0, "position:y", 0.5, 0.5)
	tween_column.tween_property($Parkour/Column1, "position:y", 1, 1)
	tween_column.tween_property($Parkour/Column2, "position:y", 1.5, 1.5)
	tween_column.tween_property($Parkour/Column3, "position:y", 2, 2)
	tween_column.tween_property($Parkour/Column4, "position:y", 2.5, 2.5)
	tween_column.tween_property($Parkour/Column5, "position:y", 2.5, 3)
