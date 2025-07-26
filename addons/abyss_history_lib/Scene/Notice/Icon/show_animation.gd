extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func play():
	anim.play("Show")
