@tool
extends Node3D
class_name Interactive

signal interact_signal
signal init_behavior_signal

@export var DisplayName : String = ""
@export var init_behavior : Array[BehaviorClass]:
	set(behavior_in):
		init_behavior = behavior_in
		init_behavior_signal.emit()
@export_group("Interact")
@export var Interactable : bool = false
@export var interact_icon : String = "🤚"
@export var interact_text : String = "interact.interact"
@export var interact_behavior : Array[BehaviorClass]
@export var Switchable : bool = false
@export var state : bool = true:
	set(state_in):
		state = state_in
		interact_signal.emit()
@export_group("Hurtable")
@export var Hurtable : bool = false
@export var MaxHealth : float = 100
@export var current_health : float
@export var hurt_behavior : Array[BehaviorClass]
@export var killed_behavior : Array[BehaviorClass]
@export_group("Touch")
@export var touch_behavior : Array[BehaviorClass]

func _ready() -> void:
	current_health = MaxHealth
	for i in init_behavior:
		i.do(self,null)
	init_behavior_signal.emit()

func interact(sender):
	if Switchable:
		state = !state
		
	for i in interact_behavior:
		i.do(self,sender)
	
func receive_attack(damage_res:DamageResClass,sender):
	if Hurtable:
		if current_health >= 0:
			current_health -= damage_res.damage_point
		if current_health > 0:
			for i in hurt_behavior:
				i.do(self,sender)
		else:
			for i in killed_behavior:
				i.do(self,sender)
