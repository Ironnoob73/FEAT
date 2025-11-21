@tool
extends Node3D
class_name AHL_Interactive

signal interact_signal(interactor,sender)
signal init_behavior_signal
signal killed_signal(interactor,sender)
signal touch_signal
signal on_user_change
signal on_user_leave(user)

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
@export var state : bool = false:
	set(state_in):
		state = state_in
		if Engine.is_editor_hint():
			interact_signal.emit(self,null)
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
				new_user.isUsing = self
## 当使用者离开时执行的行为。
@export var leave_behavior : Array[AHL_BehaviorClass]

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
	
	interact_signal.emit(self,sender)
	
func receive_attack(damage_res:AHL_DamageResClass,sender):
	if Hurtable:
		if current_health >= 0:
			current_health -= damage_res.damage_point
		if current_health > 0:
			for i in hurt_behavior:
				i.set_meta("damage_res",damage_res)
				i.do(self,sender)
		else:
			for i in killed_behavior:
				i.set_meta("damage_res",damage_res)
				killed_signal.emit(self,sender)
				i.do(self,sender)

func touch(sender):
	for i in touch_behavior:
		i.do(self,sender)
	touch_signal.emit()

func leave(sender):
	if sender != null:
		for i in leave_behavior:
			i.do(self,sender)
		sender.isUsing = null
		on_user_leave.emit(sender)
		
## 强制移除使用者。
func force_leave():
	user = null
