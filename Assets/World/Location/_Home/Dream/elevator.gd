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

@onready var elevator_door : AHL_Interactive = $ElevatorDoor
@onready var alert_sound : AudioStreamPlayer3D = $NumberPad/Pad/AlertSound

@export var current_level : int = 5
var requested_level : Array[int]

func _on_alert_interact_signal(_i: AHL_Interactive, _s: Node) -> void:
	alert_sound.play(0.08)

func _request_level(interactor: TextedButton3d, _sender: Node) -> void:
	if interactor.text.to_int() != current_level:
		if !requested_level.has(interactor.text.to_int()):
			requested_level.append(interactor.text.to_int())
	else:
		await interactor.timeout_unlit()

func _request_cancel(interactor: TextedButton3d, _sender: Node) -> void:
	requested_level.erase(interactor.text.to_int())
