class_name player
extends CharacterBody3D

@export var player_name : String = 'Anonymous'

var load_step : int = 0

const SPEED = 5
const DASH = 8
const CROUCH = 3
const CROUCH_depth = 0.5
const JUMP_VELOCITY = 8
const SIT_depth = 0.75

const ACCELERATION = 0.1
const FRICTION = 0.3

const MAX_STEP_HEIGHT = 0.5

var isDash: float = 0
var isCrouch: float = 0
var isClimb: bool = false
var isSit: Node = null
var isThirdPerson: bool = false
var isInTeleport: bool = false

@onready var player_collision = $PlayerColl
@onready var mesh = $BodyScene

@onready var hand_held : Node
var hand_held_group : Array[Node]

@export var Inventory : AHL_InventoryClass
var current_hotbar : int = 0
var handheld_tool : AHL_EqMetaClass

@export var MaxHealth : float = 100
@export var current_health : float = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var att_idle : bool = true
var att_sec : bool = false
var att_order : bool = false

func _ready():
	
	if !Inventory:
		Inventory = CInventoryClass.new()
		Inventory.ItemHotbar.append_array([null,null,null,null,null])
		Inventory.ToolHotbar.append_array([null,null,null,null,null])
	
	refresh_player_mesh()
	refresh_handheld(current_hotbar)
	
func refresh_handheld(index:int):
	mesh.animation_tree["parameters/MainAttack/request"] = 3
	handheld_tool = Inventory.ToolHotbar[current_hotbar]
	if index == current_hotbar:
		for n in hand_held_group:
			if n and n.get_children():
				n.get_child(0).queue_free()
				n.get_child(0).free()
			if handheld_tool:
				if handheld_tool.equipment.scene:
					n.add_child(handheld_tool.equipment.scene.instantiate())
					n.get_child(0)._tool_init()
				else :
					var handheld_model = MeshInstance3D.new()
					handheld_model.mesh = handheld_tool.equipment.model
					handheld_model.material_override = handheld_tool.equipment.material
					handheld_model.position = handheld_tool.equipment.pos_offset
					handheld_model.rotation = handheld_tool.equipment.pos_rotation_rad()
					handheld_model.scale = handheld_tool.equipment.pos_scale
					handheld_model.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
					handheld_model.set_layer_mask_value(5,true)
					if handheld_tool.equipment.the_script :
						handheld_model.set_script(handheld_tool.equipment.the_script)
					n.add_child(handheld_model)
				set_attack_animation(handheld_tool.equipment.attack_type)
				if handheld_tool.equipment.attack_type == "Aimable":
					mesh.animation_tree["parameters/MainAttack/request"] = 1
			else :
				set_attack_animation("DoubleHand")
	if hand_held.get_children():
		for i in hand_held.get_children():
			if isThirdPerson:
				i.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
			else:
				i.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY

func refresh_player_mesh():
	if mesh.right_hand_pos != null:
		hand_held = mesh.right_hand_pos

func set_attack_animation(type:String = "Light"):
	mesh.animation_tree["parameters/AttackStateMachine/conditions/DoubleHand"] = false
	mesh.animation_tree["parameters/AttackStateMachine/conditions/Light"] = false
	mesh.animation_tree["parameters/AttackStateMachine/conditions/Aimable"] = false
	match type:
		"DoubleHand":	mesh.animation_tree["parameters/AttackStateMachine/conditions/DoubleHand"] = true
		"Light":	mesh.animation_tree["parameters/AttackStateMachine/conditions/Light"] = true
		"Aimable":	mesh.animation_tree["parameters/AttackStateMachine/conditions/Aimable"] = true
