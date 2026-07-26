class_name Elevator
extends Node3D

## Icons:
## https://www.svgrepo.com/svg/520959/snow
## https://www.svgrepo.com/svg/342626/gem
## https://www.svgrepo.com/svg/472454/book-bookmark
## https://www.svgrepo.com/svg/435832/device-24px
## https://www.svgrepo.com/svg/510001/home
## https://www.svgrepo.com/svg/391159/candy
## https://www.svgrepo.com/svg/391306/plant-pot
## https://www.svgrepo.com/svg/521619/drop
## https://www.svgrepo.com/svg/136064/cloud-computing
##
## Sounds:
## https://pixabay.com/sound-effects/household-telephone-ring-old-german-w48-83246/

signal request_arrow(arrow: String)
signal request_to_level(interactor: Node, sender: Node, to_level: int)
signal request_out()

@export var current_level : int = 5
var requested_level : Array[int]
var is_waiting: bool = false

@onready var elevator_door : ElevatorDoor = $ElevatorDoor
@onready var left_arrow: Label3D = $NumberPad/Screen/LeftArrow

@onready var level_9_button: TextedButton3d = $NumberPad/Pad/Level9
@onready var level_8_button: TextedButton3d = $NumberPad/Pad/Level8
@onready var level_7_button: TextedButton3d = $NumberPad/Pad/Level7
@onready var level_6_button: TextedButton3d = $NumberPad/Pad/Level6
@onready var level_5_button: TextedButton3d = $NumberPad/Pad/Level5
@onready var level_4_button: TextedButton3d = $NumberPad/Pad/Level4
@onready var level_3_button: TextedButton3d = $NumberPad/Pad/Level3
@onready var level_2_button: TextedButton3d = $NumberPad/Pad/Level2
@onready var level_1_button: TextedButton3d = $NumberPad/Pad/Level1

func _request_level(interactor: TextedButton3d, sender: Node) -> void:
	if interactor.text.to_int() != current_level and ((not requested_level.size()) or (
			((requested_level.get(0) > current_level and interactor.text.to_int() > current_level)\
			or (requested_level.get(0) < current_level and interactor.text.to_int() < current_level)))):
		if !requested_level.has(interactor.text.to_int()):
			requested_level.append(interactor.text.to_int())
		if not is_waiting:
			await go_to_level(sender)
	else:
		await interactor.timeout_unlit()

func _request_cancel(interactor: TextedButton3d, _sender: Node) -> void:
	requested_level.erase(interactor.text.to_int())

func go_to_level(_sender: Node) -> void:
	is_waiting = true
	left_arrow.show()
	request_arrow.emit("▲" if requested_level.get(0) > current_level else "▼")
	await get_tree().create_timer(1.5,false,true,false).timeout
	if requested_level.size():
		elevator_door.switch(false, self)
		await elevator_door.closing_done
		var parent_scene: sub_room_viewport = get_parent()
		if parent_scene.own_world_3d:
			request_to_level.emit(null, self, requested_level.min() if requested_level.get(0) > current_level else requested_level.max())
	else:
		is_waiting = false
		left_arrow.hide()

func _on_request_arrow(arrow: String) -> void:
	left_arrow.text = arrow

func _can_go_next_level() -> void:
	if requested_level.size():
		var arrived_level: int = requested_level.min() if requested_level.get(0) > current_level else requested_level.max()
		requested_level.erase(arrived_level)
		await _unlit_button_after_arrive(arrived_level)
		if requested_level.size():
			await go_to_level(self)
		else:
			request_out.emit()
			is_waiting = false

func _unlit_button_after_arrive(level: int) -> void:
	match level:
		1:
			await level_1_button.timeout_unlit()
		2:
			await level_2_button.timeout_unlit()
		3:
			await level_3_button.timeout_unlit()
		4:
			await level_4_button.timeout_unlit()
		5:
			await level_5_button.timeout_unlit()
		6:
			await level_6_button.timeout_unlit()
		7:
			await level_7_button.timeout_unlit()
		8:
			await level_8_button.timeout_unlit()
		9:
			await level_9_button.timeout_unlit()

func _just_closing_the_door() -> void:
	if requested_level.size():
		elevator_door.switch(false, self)
