extends AHL_BehaviorClass
class_name AHL_PlaySoundBehaviorClass
## 播放声音的行为。

@export var sound: AudioStream = null
@export_enum("Master", "Music", "SFX") var bus: String = "SFX"
@export var from: float = 0.0
@export var pitch: float = 1.0

func do(interactor: Node, sender: Node) -> void:
	var soundPlayer: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	interactor.get_tree().get_root().add_child(soundPlayer)
	soundPlayer.global_position = interactor.global_position
	soundPlayer.bus = bus
	if sound:
		soundPlayer.stream = sound
		soundPlayer.pitch_scale = pitch
		soundPlayer.play(from)
		soundPlayer.connect("finished", func() -> void: soundPlayer.queue_free(), 1)
	else:
		soundPlayer.queue_free()
