@tool
extends Node3D

@export var MaxHealth : float = 100
@export var current_health : float

func get_class() -> String:	return "Hurtable"

func _ready() -> void:
	current_health = MaxHealth

func receive_attack(damage_point:float,attack_type:String = "Normal"):
	current_health -= damage_point
	if current_health <= 0:
		print("Killed")
