extends CanvasLayer
## @tutorial(From): https://forum.godotengine.org/t/how-to-keep-surface-material-override-didnt-change/59110 https://www.youtube.com/watch?v=Wnkc_qUXYWs

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var progress_bar : ProgressBar = $Background/ProgressBar
@onready var progress_number : Label = $Background/ProgressNumber

func _update_progress(value : float) -> void:
	progress_bar.set_value_no_signal(value)
	progress_number.text = str(value * 100) + "%"
	
func _outro() -> void:
	animation.play("Outro")
	await Signal(animation, "animation_finished")
	self.queue_free()

func _fail(info : String) -> void:
	progress_number.text = "ERROR: " + info
