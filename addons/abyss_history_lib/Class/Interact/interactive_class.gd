@tool
@icon("interactive_icon.svg")
class_name AHL_Interactive
extends Node3D

signal interact_signal(interactor: Node, sender: Node)
signal init_behavior_signal
signal state_change_signal(state: bool, sender: Node)
signal killed_signal(interactor: Node, sender: Node)
signal touch_signal
signal on_user_change
signal on_user_leave(user: Node)

@export var DisplayName : String = ""
@export var init_behavior : Array[AHL_BehaviorClass]:
	set(behavior_in):
		init_behavior = behavior_in
		init_behavior_signal.emit()
@export_group("Interact")
@export var Hidden : bool = false
@export var Interactable : bool = false
@export var interact_icon : String = "\U01F91A"
@export var interact_text : String = "interact.interact"
@export var interact_behavior : Array[AHL_BehaviorClass]
@export var Switchable : bool = false

## 当Switchable开启，该项用于控制可交互体的开启状态。
## !!!需要重新思考修改方式!!!
## 目前直接修改该项没有任何作用，仅用于初始化时修改状态而保留。
@export var state : bool = false
	
@export_group("Hurtable")
## 该节点是否可以被攻击
@export var Hurtable : bool = false
@export var MaxHealth : float = 100
@export var current_health : float
@export var hurt_behavior : Array[AHL_BehaviorClass]
@export var killed_behavior : Array[AHL_BehaviorClass]
@export_group("Touch")
@export var touch_behavior : Array[AHL_BehaviorClass]
@export_group("User")
## 该节点被附加的使用者（例如椅子），只有当交互行为主动为该变量添加节点时才会用到。
var user : Node3D:
	set(new_user):
		if user != new_user:
			on_user_change.emit()
			leave(user)
			user = new_user
			if new_user is LocalPlayer:
				var player_user: LocalPlayer = new_user
				player_user.is_using = self
## 当使用者离开时执行的行为。
@export var leave_behavior : Array[AHL_BehaviorClass]

func _ready() -> void:
	current_health = MaxHealth
	for i: AHL_BehaviorClass in init_behavior:
		i.do(self,null)
	init_behavior_signal.emit()

func interact(sender:Node) -> void:
	if Switchable:
		switch(!state, sender)
		
	for i: AHL_BehaviorClass in interact_behavior:
		i.do(self, sender)
	
	interact_signal.emit(self, sender)
	
func switch(value: bool, sender: Node) -> void:
	state = value
	state_change_signal.emit(value, sender)
	
func receive_attack(damage_res:AHL_DamageResClass,sender:Node) -> void:
	if Hurtable:
		if current_health >= 0:
			current_health -= damage_res.damage_point
		if current_health > 0:
			for i: AHL_BehaviorClass in hurt_behavior:
				i.set_meta("damage_res",damage_res)
				i.do(self,sender)
		else:
			for i: AHL_BehaviorClass in killed_behavior:
				i.set_meta("damage_res",damage_res)
				killed_signal.emit(self,sender)
				i.do(self,sender)

func touch(sender: Node) -> void:
	for i: AHL_BehaviorClass in touch_behavior:
		i.do(self,sender)
	touch_signal.emit()

func leave(sender: Node) -> void:
	if sender != null:
		for i: AHL_BehaviorClass in leave_behavior:
			i.do(self,sender)
		if sender is LocalPlayer:
			var player_sender: LocalPlayer = sender
			player_sender.is_using = null
		on_user_leave.emit(sender)
		
## 强制移除使用者。
func force_leave() -> void:
	user = null
