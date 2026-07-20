extends StaticBody3D

@onready var elevator_door: AHL_Interactive = $"../ElevatorDoor"
@onready var alert_sound: AudioStreamPlayer3D = $Pad/AlertSound

func _timeout_unlit(interactor: AHL_Interactive) -> void:
	var timer : SceneTreeTimer
	if interactor.get_meta("timer") != null:
		timer = interactor.get_meta("timer")
		timer.set_time_left(0.5)
	else:
		timer = get_tree().create_timer(0.5,false,true,false)
	interactor.set_meta("timer", timer)
	await timer.timeout
	interactor.remove_meta("timer")
	interactor.state = false

func _on_open_interact_signal(interactor: AHL_Interactive, _s: Variant) -> void:
	elevator_door.switch(true)
	await _timeout_unlit(interactor)

func _on_close_interact_signal(interactor: AHL_Interactive, _s: Variant) -> void:
	elevator_door.switch(false)
	await _timeout_unlit(interactor)

func _on_alert_interact_signal(interactor: AHL_Interactive, _sender: Variant) -> void:
	alert_sound.play(0.08)
	await _timeout_unlit(interactor)

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
