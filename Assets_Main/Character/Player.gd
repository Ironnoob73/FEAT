extends CharacterBody3D

var load_step : int = 0

const SPEED = 5
const DASH = 8
const CROUCH = 3
const CROUCH_depth = 0.5
const JUMP_VELOCITY = 8

const ACCELERATION = 0.1
const FRICTION = 0.3

const MAX_STEP_HEIGHT = 0.5

var isDash = 0
var isCrouch = 0
var isClimb : bool = false
var isSit : bool = false
var isThirdPerson : bool = true

@onready var player_collision = $PlayerColl
@onready var player_camera = $PlayerCam
@onready var standing_detected= $StandingDetected
@onready var pause_menu = $Pause_menu
@onready var inventory_menu = $Inventory
@onready var mesh: MeshInstance3D = $Mesh

@onready var first_person_cam = $PlayerCam/FirstPersonHandled/SubViewport/FirstPersonCam
@onready var world_actual_cam = $PlayerCam/WorldActual/SubViewport/WorldActualCam
@onready var hand_held = $PlayerCam/FirstPersonHandled/SubViewport/FirstPersonCam/HandHeld
@onready var attack_area = $PlayerCam/AttackArea
@onready var hitbox = $PlayerCam/AttackArea/Coll
@onready var third_perosn_cam: Camera3D = $ThirdPerosnCam

var perspective_in_rotate : bool = false
var perspective_rad : float = 0
var perspective_size : float = 10
var perspective_from : Vector2

@onready var interact_ray = $PlayerCam/InteractRay
@onready var interact_ray_tp: RayCast3D = $ThirdPerosnCam/InteractRayTP
@onready var cursor3: MeshInstance3D = $Cursor3

@onready var _climb_area = $PlayerColl/ClimbArea

@onready var caption = $Caption

var INERTIA:Vector2 = Vector2.ZERO

var current_menu = "HUD"
@export var isInVR : bool = false

@export var Inventory : InventoryClass
var current_hotbar : int = 0
var handheld_tool : EqMetaClass
@onready var HUD_hotbar = $HudHotbar

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Lock Mouse.
	if !isThirdPerson:
		mouse_mode(false)
	
	if !Inventory:
		Inventory = CInventoryClass.new()
		Inventory.ItemHotbar.append_array([null,null,null,null,null])
		Inventory.ToolHotbar.append_array([null,null,null,null,null])
	
	pause_menu.hide()
	inventory_menu.hide()
	refresh_handheld(current_hotbar)
	inventory_menu.init()
	
func _input(event):
	# Perspective
	if isThirdPerson:
		if Input.is_action_just_pressed("perspective"):
			perspective_from = caption.get_mouse_pos()
			perspective_in_rotate = true
		if Input.is_action_just_released("perspective"):
			perspective_in_rotate = false
		
	# Player camera.
	if event is InputEventMouseMotion and current_menu == "HUD":
		var pos = caption.get_mouse_pos()
		if isThirdPerson :
			mesh.rotation.y = -atan2(pos.y,pos.x) - PI/2
			player_camera.rotation.y = -atan2(pos.y,pos.x) - PI/2
			interact_ray_tp.position.x = pos.x * third_perosn_cam.size * 0.0011
			interact_ray_tp.position.y = -pos.y * third_perosn_cam.size * 0.0011
			cursor3.global_position = interact_ray_tp.get_collision_point()
			if perspective_in_rotate:
				rotation.y = perspective_rad - deg_to_rad(pos.x - perspective_from.x)
				third_perosn_cam.size = clamp(perspective_size + (pos.y - perspective_from.y) * 0.1,5,50)
				third_perosn_cam.position.y = third_perosn_cam.size
				third_perosn_cam.position.z = third_perosn_cam.size
			else:
				perspective_rad = self.global_rotation.y
				perspective_size = third_perosn_cam.size
		else :
			rotate_y(-deg_to_rad(event.relative.x * Global.mouse_sens))
			player_camera.rotate_x(-deg_to_rad(event.relative.y * Global.mouse_sens))
			player_camera.rotation.x = clamp(player_camera.rotation.x,deg_to_rad(-90),deg_to_rad(90))
	
func _unhandled_input(_event):
	# Pause.
	if Input.is_action_just_pressed("pause"):
		match current_menu :
			"HUD":
				current_menu = "Pause"
				mouse_mode(true)
				pause_menu.show()
			"Inventory":
				inventory_menu.close_inventory()
			"ToolSetting":
				current_menu = "HUD"
				hand_held.get_child(0).setting_off()
	# Inventory
	if Input.is_action_just_pressed("inventory"):
		match current_menu :
			"HUD":
				current_menu = "Inventory"
				mouse_mode(true)
				inventory_menu.open_inventory()
			"Inventory":
				inventory_menu.close_inventory()
			"ToolSetting":
				hand_held.get_child(0).setting_off()
				current_menu = "Inventory"
				mouse_mode(true)
				inventory_menu.open_inventory()
	# Hotbar
	if !Input.is_action_pressed("tool_function_switch") and current_menu == "HUD":
		if Input.is_action_just_pressed("hotbar_tool_0") :
			current_hotbar = 0
			refresh_handheld(current_hotbar)
		if Input.is_action_just_pressed("hotbar_tool_1") :
			current_hotbar = 1
			refresh_handheld(current_hotbar)
		if Input.is_action_just_pressed("hotbar_tool_2") :
			current_hotbar = 2
			refresh_handheld(current_hotbar)
		if Input.is_action_just_pressed("hotbar_tool_3") :
			current_hotbar = 3
			refresh_handheld(current_hotbar)
		if Input.is_action_just_pressed("hotbar_tool_4") :
			current_hotbar = 4
			refresh_handheld(current_hotbar)
	# UnSit
	if isSit and ( Input.is_action_pressed("ui_accept") or Input.is_action_pressed("crouch")) :
		isSit = false
		
	# Switch perspectives
	if Input.is_action_just_pressed("switch_perspectives") and current_menu == "HUD":
		isThirdPerson = !isThirdPerson
		mesh.rotation.y = 0
		player_camera.rotation.y = 0
		mouse_mode(isThirdPerson)
		third_perosn_cam.current = isThirdPerson
		player_camera.current = !isThirdPerson

# From : https://github.com/majikayogames/godot-character-controller-stairs/blob/main/entities/Player/Player.gd
var _was_on_floor_last_frame = false
var _snapped_to_stairs_last_frame = false
func _snap_down_to_stairs_check():
	var did_snap = false
	if not ( is_on_floor() or isClimb ) and velocity.y <= 0 and (_was_on_floor_last_frame or _snapped_to_stairs_last_frame) and $StairsBelowRayCast3D.is_colliding():
		var body_test_result = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		var max_step_down = -0.5
		params.from = self.global_transform
		params.motion = Vector3(0,max_step_down,0)
		if PhysicsServer3D.body_test_motion(self.get_rid(), params, body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true

	_was_on_floor_last_frame = is_on_floor() or isClimb
	_snapped_to_stairs_last_frame = did_snap
	
var _cur_frame = 0
@export var _jump_frame_grace = 5
var _last_frame_was_on_floor = -_jump_frame_grace - 1

# From : https://github.com/majikayogames/SimpleFPSController/blob/main/FPSController/FPSController.gd
func _push_away_rigid_bodies():
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir = -c.get_normal()
			# How much velocity the object needs to increase to match player velocity in the push direction
			var velocity_diff_in_push_dir = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			# Only count velocity towards push dir, away from character
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			# Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			const MY_APPROX_MASS_KG = 80.0
			var mass_ratio = min(1., MY_APPROX_MASS_KG / c.get_collider().mass)
			# Don't push object from above/below
			push_dir.y = 0
			# 5.0 is a magic number, adjust to your needs
			var push_force = mass_ratio * 5.0
			c.get_collider().apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)
# From : https://github.com/majikayogames/SimpleFPSController/blob/main/FPSController/FPSController.gd
func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle
func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	# Run a body_test_motion slightly above the pos we expect to move to, towards the floor.
	#  We give some clearance above to ensure there's ample room for the player.
	#  If it hits a step <= MAX_STEP_HEIGHT, we can teleport the player on top of the step
	#  along with their intended motion forward.
	var down_check_result = KinematicCollision3D.new()
	if (self.test_move(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		# Note I put the step_height <= 0.01 in just because I noticed it prevented some physics glitchiness
		# 0.02 was found with trial and error. Too much and sometimes get stuck on a stair. Too little and can jitter if running into a ceiling.
		# The normal character controller (both jolt & default) seems to be able to handled steps up of 0.1 anyway
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_position() - self.global_position).y > MAX_STEP_HEIGHT: return false
		$StairsAheadRayCast3D.global_position = down_check_result.get_position() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		$StairsAheadRayCast3D.force_raycast_update()
		if $StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep($StairsAheadRayCast3D.get_collision_normal()):
			#_save_camera_pos_for_smoothing()
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

func _physics_process(delta):
	# Record Inerita & Add the gravity.
	if is_on_floor() or isClimb:
		INERTIA.x = velocity.x
		INERTIA.y = velocity.z
	else:
		velocity.y -= gravity * 0.05

	# Handle Jump.
	_cur_frame += 1
	if is_on_floor() :
		_last_frame_was_on_floor = _cur_frame
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or _cur_frame - _last_frame_was_on_floor <= _jump_frame_grace):
		velocity.y = JUMP_VELOCITY
	
	# Move Input.
	var input_vec = Vector3.ZERO
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vec = (transform.basis * Vector3(input_vec.x,0,input_vec.z)).normalized()
	
	isDash = Input.get_action_strength("shift")
	isCrouch = Input.get_action_strength("crouch")
	
	# Move.
	velocity.x = lerp(velocity.x,input_vec.x * (SPEED + isDash * DASH * (1 - isCrouch) - isCrouch * CROUCH ) , ACCELERATION)
	velocity.z = lerp(velocity.z,input_vec.z * (SPEED + isDash * DASH * (1 - isCrouch) - isCrouch * CROUCH ) , ACCELERATION)
	# Stop.
	if velocity.x * input_vec.x <= 0 and velocity.x!=0:
		if is_on_floor() or isClimb:	velocity.x = lerp(velocity.x,0.0,FRICTION)
		else:							velocity.x = lerp(INERTIA.x,0.0,FRICTION)
	if velocity.z * input_vec.z <= 0 and velocity.z!=0:
		if is_on_floor() or isClimb:	velocity.z = lerp(velocity.z,0.0,FRICTION)
		else:							velocity.z = lerp(INERTIA.y,0.0,FRICTION)
	
	# Crouch.
	if Input.is_action_pressed("crouch") and !isClimb and !isSit :
		player_collision.shape.height = lerp(player_collision.shape.height,1.8 * CROUCH_depth,0.5)
		player_camera.position.y = lerp(player_camera.position.y,0.5 * CROUCH_depth,0.5)
	elif !standing_detected.is_colliding() :
		player_collision.shape.height = lerp(player_collision.shape.height,1.8,0.5)
		player_camera.position.y = lerp(player_camera.position.y,0.5,0.5)
	# Climb
	if isClimb:
		input_vec.y = Input.get_action_strength("ui_accept") - Input.get_action_strength("crouch")
		velocity.y = lerp(velocity.y,input_vec.y * SPEED , ACCELERATION)
	if velocity.y * input_vec.y <= 0 and velocity.y!=0 and isClimb:
		velocity.y = lerp(velocity.y,0.0,FRICTION)
		
	if not _snap_up_stairs_check(delta):
		_push_away_rigid_bodies()
		if !isSit : move_and_slide()
		_snap_down_to_stairs_check()

	#Scroll hotbar
	if current_menu == "HUD" and !Input.is_action_pressed("tool_function_switch"):
		if Input.is_action_just_pressed("roll_down"):
			if current_hotbar < 4 :	current_hotbar += 1
			else :	current_hotbar = 0
			refresh_handheld(current_hotbar)
		elif Input.is_action_just_pressed("roll_up"):
			if current_hotbar > 0 :	current_hotbar -= 1
			else :	current_hotbar = 4
			refresh_handheld(current_hotbar)
	
func _process(_delta):
	match load_step :
		0 :
			load_step += 1
		1 :
			load_step += 1
	first_person_cam.global_transform = player_camera.global_transform
	world_actual_cam.global_transform = player_camera.global_transform
	
func refresh_handheld(index:int):
	handheld_tool = Inventory.ToolHotbar[current_hotbar]
	if index == current_hotbar:
		if hand_held.get_children():
			hand_held.get_child(0).queue_free()
			hand_held.get_child(0).free()
		if handheld_tool:
			if handheld_tool.equipment.scene:
				hand_held.add_child(handheld_tool.equipment.scene.instantiate())
				hand_held.get_child(0)._tool_init()
			else :
				var handheld_model = MeshInstance3D.new()
				handheld_model.mesh = handheld_tool.equipment.model
				handheld_model.material_override = handheld_tool.equipment.material
				handheld_model.set_layer_mask_value(5,true)
				if handheld_tool.equipment.the_script :
					handheld_model.set_script(handheld_tool.equipment.the_script)
				hand_held.add_child(handheld_model)
			hitbox.shape.size = handheld_tool.equipment.hitbox
			hitbox.position.z = -hitbox.shape.size.z/2
			refresh_handheld_info()
		else :
			hitbox.shape.size = Vector3(0.25,0.25,1)
			hitbox.position.z = -0.5
			HUD_hotbar.set_info(current_hotbar)
func refresh_handheld_info():
	HUD_hotbar.set_info(current_hotbar,\
		handheld_tool.equipment.name0,\
		handheld_tool.equipment.icon,\
		((handheld_tool.equipment.durability - handheld_tool.damage)/handheld_tool.equipment.durability)*100)

# Climb Detection
func _on_climb_area_area_entered(area):
	if area.is_in_group("ClimbAble"):
		isClimb = true
func _on_climb_area_area_exited(area):
	if area.is_in_group("ClimbAble"):
		isClimb = false
		for i in _climb_area.get_overlapping_areas():
			if i.is_in_group("ClimbAble"):
				isClimb = true
# Motion Detection
func _on_motion_area_area_entered(area):
	if area.is_in_group("MotionSensing"):
		area.detected_player = self
func _on_motion_area_area_exited(area):
	if area.is_in_group("MotionSensing"):
		area.detected_player = null

# Sit
func sit( chair_position, chair_rotation):
	if !isSit :
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
		tween.tween_property(self, "position", chair_position, 0.5)
		tween.tween_property(self, "rotation:y", chair_rotation.y - deg_to_rad(180), 0.5)
		tween.tween_property(player_camera, "rotation:x", chair_rotation.x, 0.5)
		isSit = true
	else : isSit = false

# Caption
func add_caption(text_in:String):
	for i in caption.get_child_count():
		caption.get_child(i).update_pos()
	var new_caption = load("res://Assets_Main/Character/Caption/Caption.tscn").instantiate()
	new_caption.text = text_in
	caption.add_child(new_caption)
func clear_caption():
	for i in caption.get_child_count():
		caption.get_child(i)._on_timer_timeout()

func mouse_mode(isVisible:bool)->void:
	if !isThirdPerson :
		if isVisible :	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else :	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else :	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
