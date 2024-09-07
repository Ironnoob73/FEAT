@tool
extends Node3D
class_name Interactive

@export var DisplayName : String = ""
@export_group("Interact")
@export var Interactable : bool = false
@export var interact_icon : String = "🤚"
@export var interact_text : String = ""
@export var interact_behavior : Array[BehaviorClass]
@export var Switchable : bool = false
@export var state : bool = true
@export_group("Hurtable")
@export var Hurtable : bool = false
@export var MaxHealth : float = 100
@export var current_health : float
@export var hurt_behavior : Array[BehaviorClass]
@export_group("Touch")
@export var touch_behavior : Array[BehaviorClass]

signal interact_signal

func _ready() -> void:
	current_health = MaxHealth

func interact(_sender):
	if Switchable:
		state = !state
		
	for i in interact_behavior:
		match i:
			BehaviorClass:	print("null")
			SwitchClass:
				for j in i.connected_node :
					var Ni = get_node(j)
					if Ni.is_in_group("Switchable") :
						Ni.switch(state)
					else : push_warning("This connected node can't be switched.")
	
func receive_attack(damage_point:float,attack_type:String = "Normal"):
	if Hurtable:
		current_health -= damage_point
		if current_health <= 0:
			print("Killed")
