extends Node3D

func _ready():
	_on_options_set_sdfgi(Global.Sdfgi)

func _on_options_set_sdfgi(value : bool):
	if Global.isInGame:
		$WorldEnvironment.environment.set_sdfgi_enabled(value)
