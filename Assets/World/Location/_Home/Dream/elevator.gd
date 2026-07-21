extends StaticBody3D

@onready var elevator_door: AHL_Interactive = $"../ElevatorDoor"
@onready var alert_sound: AudioStreamPlayer3D = $Pad/AlertSound


func _on_open_interact_signal(_i: AHL_Interactive, sender: Node) -> void:
	elevator_door.switch(true, sender)

func _on_close_interact_signal(_i: AHL_Interactive, sender: Node) -> void:
	elevator_door.switch(false, sender)

func _on_alert_interact_signal(_i: AHL_Interactive, _s: Node) -> void:
	alert_sound.play(0.08)

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
