extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func play() -> void:
	anim.play("Show")
