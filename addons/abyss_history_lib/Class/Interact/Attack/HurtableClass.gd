@tool
extends Node3D

func get_class() -> String:	return "Hurtable"

func receive_attack(damage_point:float,attack_type:String = "Normal"):
	print(damage_point,attack_type)
