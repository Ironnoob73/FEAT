class_name LocalPlayer
extends Player

@onready var player_camera: Camera3D = $PlayerCam
@onready var standing_detected: ShapeCast3D = $StandingDetected
@onready var pause_menu: ColorRect = $Pause_menu
@onready var chat_menu: PlayerChat = $Chat
@onready var inventory_menu: PlayerInventory = $Inventory

@onready var first_person_cam: Camera3D = $PlayerCam/FirstPersonHandled/SubViewport/FirstPersonCam
@onready var world_actual_cam: Camera3D = $PlayerCam/WorldActual/SubViewport/WorldActualCam
@onready var hand_held_fp: HandHeldAnimation = $PlayerCam/FirstPersonHandled/SubViewport/FirstPersonCam/HandHeldRight
@onready var lerp_cam: Camera3D = $PlayerCam/LerpCam
var lerp_cam_back: bool = false
@onready var attack_area: Area3D = $PlayerColl/AttackArea
@onready var hitbox: CollisionShape3D = $PlayerColl/AttackArea/Coll
@onready var hitbox_debug: MeshInstance3D = $PlayerColl/AttackArea/MeshInstance3D
@onready var third_perosn_cam: Camera3D = $ThirdPerosnCam

var perspective_in_rotate: bool = false
var perspective_rad: float = 0
var perspective_size: float = 10
var perspective_from: Vector2
# Interact
@onready var interact_ray: RayCast3D = $PlayerCam/InteractRay
@onready var Facing: RayCast3D = $PlayerCam/Facing
@onready var FacingTarget: Node3D = $PlayerCam/Facing/FacingTarget
@onready var interact_ray_tp: RayCast3D = $ThirdPerosnCam/InteractRayTP
@onready var interact_ray_tp_test: RayCast3D = $ThirdPerosnCam/InteractRayTP/InteractRayTPTest
@onready var cursor3: MeshInstance3D = $Cursor3
var is_using: AHL_Interactive = null
# Environment interact
@onready var _climb_area: Area3D = $PlayerColl/ClimbArea
@onready var _ground_ray_cast: RayCast3D = $GroundRayCast
var _walk_length: float = 0

#var _cur_frame: int = 0
#@export var _jump_frame_grace: int = 5
#var _last_frame_was_on_floor: int = -_jump_frame_grace - 1
var _last_frame_was_on_floor: float = -INF
var _was_on_floor_last_frame: bool = false
var _snapped_to_stairs_last_frame: bool = false
@onready var stairs_ahead_ray_cast_3d: RayCast3D = $StairsAheadRayCast3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_dir: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")

var DEBUG_LAST_STEP: String

@onready var transition: ColorRect = $Transition
@onready var caption: PlayerHUDCaption = $Caption
@onready var gradient_background: MeshInstance3D = $ThirdPerosnCam/Background

var INERTIA: Vector2 = Vector2.ZERO

var current_menu: String = "HUD":
	set(menu_name):
		current_menu = menu_name
		var error: Error = emit_signal("on_menu_change")
		if error != OK:
			push_warning("Signal \"on_menu_change\" caused an error: ", error, ".", error_string(error))
signal on_menu_change
var hud_hidden: bool = false
@export var isInDream: bool = false

@onready var HUD_hotbar: HudHotBar = $HudHotbar
@onready var HUD_states_bar: Control = $HudStatesBar
@onready var HUD_hider: AnimationPlayer = $HUDHider

func _ready() -> void:
	super._ready()
	pause_menu.hide()
	inventory_menu.hide()
	inventory_menu.init()
	if !get_meta("FullReady",true):
		HUD_hotbar.hide()
		HUD_states_bar.hide()

	tird_person_setup(false,false)
	switch_perspectives()
	
	# Side process
	_snap_down_to_stairs_check()

func _input(event: InputEvent) -> void:
	# Perspective
	if isThirdPerson:
		if Input.is_action_just_pressed("perspective"):
			perspective_from = caption.get_mouse_pos()
			perspective_in_rotate = true
		if Input.is_action_just_released("perspective"):
			perspective_in_rotate = false
		
	# Player camera.
	if event is InputEventMouseMotion and current_menu in ["HUD"]:
		var mouse_motion_event: InputEventMouseMotion = event
		if isThirdPerson :
			tird_person_setup(perspective_in_rotate)
		else :
			var mouse_motion: Vector2 = mouse_motion_event.relative * Global.mouse_sens
			rotate_y(-deg_to_rad(mouse_motion.x))
			player_camera.rotate_x(-deg_to_rad(mouse_motion.y))
			player_camera.rotation.x = clamp(player_camera.rotation.x,deg_to_rad(-90),deg_to_rad(90))
		attack_area.rotation.x = player_camera.rotation.x
	
func tird_person_setup(is_rotate:bool,not_init:bool = true) -> void:
	interact_ray_tp.global_position = third_perosn_cam.project_position(caption.get_global_mouse_position(),0)
	interact_ray_tp.set_collision_mask_value(6,!interact_ray_tp_test.is_colliding())
	var pos: Vector2 = caption.get_mouse_pos()
	var offset_pos: Vector3 = interact_ray_tp.get_collision_point() - global_position
	player_camera.rotation.y = - atan2(offset_pos.z,offset_pos.x) - PI/2 - self.global_rotation.y
	mesh.rotation.y = player_camera.rotation.y + PI
	attack_area.rotation.y = player_camera.rotation.y
	player_camera.rotation.x = atan2(offset_pos.y - 1.7,Vector2(offset_pos.x,offset_pos.z).length())
	cursor3.global_position = interact_ray_tp.get_collision_point()
	if is_rotate:
		rotation.y = perspective_rad - deg_to_rad((pos.x if not_init else 0.0) - perspective_from.x)
		third_perosn_cam.size = clamp(perspective_size + ((pos.y if not_init else 0.0) - perspective_from.y) * 0.1,5,50)
		third_perosn_cam.position.y = third_perosn_cam.size + 0.9
		third_perosn_cam.position.z = third_perosn_cam.size
		var background_mesh: QuadMesh = gradient_background.mesh
		background_mesh.size.x = third_perosn_cam.size * 2
		background_mesh.size.y = third_perosn_cam.size * 2.5
	else:
		perspective_rad = self.global_rotation.y
		perspective_size = third_perosn_cam.size
func switch_perspectives() -> void:
	mesh.rotation.y = PI
	attack_area.rotation.y = 0
	player_camera.rotation.y = 0
	player_camera.rotation.x = 0
	mouse_mode(isThirdPerson)
	third_perosn_cam.current = isThirdPerson
	player_camera.current = !isThirdPerson
	mesh.change_visible(mesh,isThirdPerson)
	var _vec2_tbd: Vector2 = caption.get_mouse_pos()
	
func _unhandled_input(event: InputEvent) -> void:
	# Pause.
	if event.is_action_pressed("ui_cancel"):
		match current_menu :
			"HUD":
				current_menu = "Pause"
				Global.current_menu = "Pause"
				mouse_mode(true)
				pause_menu.show()
			"Inventory":
				var _b: bool = inventory_menu.close_inventory()
			"ToolSetting":
				current_menu = "HUD"
				# TODO: Item with setting
				#hand_held.get_child(0).setting_off()
			"Chat":
				current_menu = "HUD"
				mouse_mode(false)
				chat_menu.isInput = false
			_:
				if !self.get_meta("lock_menu",false):
					current_menu = "HUD"
	# Chat
	if event.is_action_pressed("chat"):
		match current_menu:
			"HUD":
				current_menu = "Chat"
				mouse_mode(true)
				chat_menu.isInput = true
			#"Chat":
			#	current_menu = "HUD"
			#	chat_menu.isInput = false
	# Inventory
	if event.is_action_pressed("inventory"):
		match current_menu :
			"HUD":
				current_menu = "Inventory"
				mouse_mode(true)
				inventory_menu.open_inventory()
			"Inventory":
				var _b: bool = inventory_menu.close_inventory()
			"ToolSetting":
				# TODO: Item with setting
				#hand_held.get_child(0).setting_off()
				current_menu = "Inventory"
				mouse_mode(true)
				inventory_menu.open_inventory()
	# Hide HUD
	if event.is_action_pressed("hide_hud")\
		and current_menu == "HUD"\
		and !self.get_meta("lock_hud_hidden",false):
		hide_hud(!hud_hidden)
	# Hotbar
	if !event.is_action_pressed("tool_function_switch") and current_menu == "HUD":
		if event.is_action_pressed("hotbar_tool_0") :
			current_hotbar = 0
			refresh_handheld(current_hotbar)
		if event.is_action_pressed("hotbar_tool_1") :
			current_hotbar = 1
			refresh_handheld(current_hotbar)
		if event.is_action_pressed("hotbar_tool_2") :
			current_hotbar = 2
			refresh_handheld(current_hotbar)
		if event.is_action_pressed("hotbar_tool_3") :
			current_hotbar = 3
			refresh_handheld(current_hotbar)
		if event.is_action_pressed("hotbar_tool_4") :
			current_hotbar = 4
			refresh_handheld(current_hotbar)
	# UnSit
	if isSit and (event.is_action_pressed("jump") or event.is_action_pressed("crouch")) :
		_un_sit()
		
	# Switch perspectives
	if event.is_action_pressed("switch_perspectives") and current_menu == "HUD":
		isThirdPerson = !isThirdPerson
		switch_perspectives()

## 下楼梯检测。
## 暂时不使其起作用了
## From : https://github.com/majikayogames/godot-character-controller-stairs/blob/main/entities/Player/Player.gd
func _snap_down_to_stairs_check() -> void:
	var did_snap: bool = false
	var StairsBelow: RayCast3D = $StairsBelowRayCast3D
	StairsBelow.force_raycast_update()
	var floor_below : bool = StairsBelow.is_colliding() and not is_surface_too_steep(StairsBelow.get_collision_normal())
	_was_on_floor_last_frame = Engine.get_physics_frames() == _last_frame_was_on_floor
	if not ( is_on_floor() or isClimb ) and velocity.y <= 0 and (_was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
		var params: PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
		var max_step_down: float = -0.5
		params.from = self.global_transform
		params.motion = Vector3(0,max_step_down,0)
		if PhysicsServer3D.body_test_motion(self.get_rid(), params, body_test_result):
			var translate_y: float = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true

	_snapped_to_stairs_last_frame = did_snap
	
	#if self.is_physics_processing():
	#	await get_tree().create_timer(0.1,false,true,false).timeout
	#	_snap_down_to_stairs_check()

## 将其他物体推开。
## From : https://github.com/majikayogames/SimpleFPSController/blob/main/FPSController/FPSController.gd
func _push_away_rigid_bodies() -> void:
	for i: int in get_slide_collision_count():
		var c: KinematicCollision3D = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var c_col: RigidBody3D = c.get_collider()
			var push_dir: Vector3 = -c.get_normal()
			# How much velocity the object needs to increase to match player velocity in the push direction
			var velocity_diff_in_push_dir: float = self.velocity.dot(push_dir) - c_col.linear_velocity.dot(push_dir)
			# Only count velocity towards push dir, away from character
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			# Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			const MY_APPROX_MASS_KG: float = 80.0
			var mass_ratio: float = min(1.0, MY_APPROX_MASS_KG / c_col.mass)
			# Don't push object from above/below
			push_dir.y = 0
			# 5.0 is a magic number, adjust to your needs
			var push_force: float = mass_ratio * 5.0
			c_col.apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c_col.global_position)
## 站立表面是否太陡检测。
## From : https://github.com/majikayogames/SimpleFPSController/blob/main/FPSController/FPSController.gd
func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle
## 上楼梯检测
func _snap_up_stairs_check(delta: float) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame:
		return false
	var expected_move_motion: Vector3 = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance: Transform3D = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	# Run a body_test_motion slightly above the pos we expect to move to, towards the floor.
	#  We give some clearance above to ensure there's ample room for the player.
	#  If it hits a step <= MAX_STEP_HEIGHT, we can teleport the player on top of the step
	#  along with their intended motion forward.
	var down_check_result: KinematicCollision3D = KinematicCollision3D.new()
	if (self.test_move(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height: float = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		# Note I put the step_height <= 0.01 in just because I noticed it prevented some physics glitchiness
		# 0.02 was found with trial and error. Too much and sometimes get stuck on a stair. Too little and can jitter if running into a ceiling.
		# The normal character controller (both jolt & default) seems to be able to handled steps up of 0.1 anyway
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_position() - self.global_position).y > MAX_STEP_HEIGHT:
			return false
		stairs_ahead_ray_cast_3d.global_position = down_check_result.get_position() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		stairs_ahead_ray_cast_3d.force_raycast_update()
		if stairs_ahead_ray_cast_3d.is_colliding() and not is_surface_too_steep(stairs_ahead_ray_cast_3d.get_collision_normal()):
			#_save_camera_pos_for_smoothing()
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

func _physics_process(delta: float) -> void:
	Global.p_elem_debug("### PP START ###")
	# Record Inerita & Add the gravity.
	Global.p_elem_debug("# GRAVITY #")
	if is_on_floor() or isClimb:
		_last_frame_was_on_floor = Engine.get_physics_frames()
		INERTIA.x = velocity.x
		INERTIA.y = velocity.z
	else:
		#velocity *= (1.1 - FRICTION) 
		velocity += gravity * 0.05 * gravity_dir
	
	# Move Input.
	Global.p_elem_debug("# MOVE INPUT #")
	var input_vec: Vector3 = Vector3.ZERO
	if current_menu == "HUD":
		input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vec.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
		isDash = Input.get_action_strength("shift")
		isCrouch = Input.get_action_strength("crouch")
		
	input_vec = (transform.basis * Vector3(input_vec.x,0,input_vec.z)).normalized()
	
	# Move.
	Global.p_elem_debug("# MOVE #")
	velocity.x = lerp(velocity.x,input_vec.x * (SPEED + isDash * DASH * (1 - isCrouch) - isCrouch * CROUCH ) , ACCELERATION)
	velocity.z = lerp(velocity.z,input_vec.z * (SPEED + isDash * DASH * (1 - isCrouch) - isCrouch * CROUCH ) , ACCELERATION)
	# Stop.
	Global.p_elem_debug("# STOP #")
	if velocity.x * input_vec.x <= 0 and velocity.x!=0:
		if is_on_floor() or isClimb:
			velocity.x = lerp(velocity.x,0.0,FRICTION)
		else:
			velocity.x = lerp(INERTIA.x,0.0,FRICTION)
	if velocity.z * input_vec.z <= 0 and velocity.z!=0:
		if is_on_floor() or isClimb:
			velocity.z = lerp(velocity.z,0.0,FRICTION)
		else:
			velocity.z = lerp(INERTIA.y,0.0,FRICTION)
	
	# Crouch & Sit (Collision shape & Camera Pos)
	Global.p_elem_debug("# CROUCH #")
	var player_collision_shape: CapsuleShape3D = player_collision.shape
	player_collision.position.y = player_collision_shape.height * 0.5
	if !isSit:
		if isCrouch and !isClimb and current_menu == "HUD":
			player_collision_shape.height = lerp(player_collision_shape.height,1.8 * CROUCH_depth,0.5)
			player_camera.position.y = lerp(player_camera.position.y,1.8 * CROUCH_depth,0.5)
		elif !standing_detected.is_colliding():
			player_collision_shape.height = lerp(player_collision_shape.height,1.8,0.5)
			player_camera.position.y = lerp(player_camera.position.y,1.7,0.5)
	else:
		player_camera.position.y = 1.8 * SIT_depth
	# Climb
	Global.p_elem_debug("# CLIMB #")
	if isClimb:
		if current_menu == "HUD":
			input_vec.y = Input.get_action_strength("jump") - Input.get_action_strength("crouch")
		velocity.y = lerp(velocity.y,input_vec.y * SPEED , ACCELERATION)
	if velocity.y * input_vec.y <= 0 and velocity.y!=0 and isClimb:
		velocity.y = lerp(velocity.y,0.0,FRICTION)
	# Handle Jump.
	Global.p_elem_debug("# JUMP #")
	if is_on_floor() or _snapped_to_stairs_last_frame:
		if current_menu == "HUD" and Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			
	Global.p_elem_debug("#! MAS !#")
	if not _snap_up_stairs_check(delta):
		_push_away_rigid_bodies()
		if !isSit && !isInTeleport:
			var _slide: bool = move_and_slide()
		#_snap_down_to_stairs_check()

	#Scroll hotbar
	Global.p_elem_debug("# SCROLL #")
	if current_menu == "HUD" and !Input.is_action_pressed("tool_function_switch"):
		if Input.is_action_just_pressed("roll_down"):
			if current_hotbar < 4 :	current_hotbar += 1
			else :	current_hotbar = 0
			refresh_handheld(current_hotbar)
		elif Input.is_action_just_pressed("roll_up"):
			if current_hotbar > 0 :	current_hotbar -= 1
			else :	current_hotbar = 4
			refresh_handheld(current_hotbar)

	Global.p_elem_debug("### PP END ###")
	
func _process(_delta: float) -> void:
	Global.p_elem_debug("### P START ###")
	Global.p_elem_debug("# LOAD STEP #")
	match load_step :
		0 :
			load_step += 1
		1 :
			load_step += 1
	first_person_cam.global_transform = player_camera.global_transform
	world_actual_cam.global_transform = player_camera.global_transform
	
	# Animation
	Global.p_elem_debug("# ANIMATION #")
	var _move_direct: float= (abs(Vector2(cos(mesh.global_rotation.y + PI/2),sin(mesh.global_rotation.y + PI/2)).angle_to(Vector2(-velocity.x , velocity.z))) /PI )
	if !isSit:
		mesh.animation_tree["parameters/Movement/blend_position"] = _forward_strength(_move_direct) * Vector2(velocity.x , velocity.z).length()
		mesh.animation_tree["parameters/SideMix/add_amount"] = _move_direct * Vector2(velocity.x , velocity.z).length() / 10
		var player_collision_shape: CapsuleShape3D = player_collision.shape
		var add_amount: float = mesh.animation_tree["parameters/CrouchMix/add_amount"]
		mesh.animation_tree["parameters/CrouchMix/add_amount"] = lerpf(add_amount, (1.8 - player_collision_shape.height) * 1.5, 0.5)
		mesh.animation_tree["parameters/PitchMix/add_amount"] = - player_camera.rotation.x
	var blend_amount: float = mesh.animation_tree["parameters/FallMix/blend_amount"]
	if velocity.y < 0:
		var min_velocity: float = min(abs(velocity.y), 0.8)
		mesh.animation_tree["parameters/FallMix/blend_amount"] = lerpf(blend_amount, min_velocity, 0.1)
	else:
		mesh.animation_tree["parameters/FallMix/blend_amount"] = lerpf(blend_amount, 0, 0.1)
	
	# Lerp Camera Animation
	Global.p_elem_debug("# LERP CAMERA #")
	if lerp_cam.current and lerp_cam_back:
		if lerp_cam.global_position.distance_to(player_camera.global_position) < 0.01 \
		and abs(lerp_cam.global_rotation.x - player_camera.global_rotation.x) < 0.01 \
		and abs(lerp_cam.global_rotation.y - player_camera.global_rotation.y) < 0.01 \
		and abs(lerp_cam.global_rotation.z - player_camera.global_rotation.z) < 0.01 :
			player_camera.make_current()
			lerp_cam_back = false
		lerp_cam.global_position = lerp_cam.position.lerp(player_camera.global_position,0.25)
		lerp_cam.global_rotation.x = lerp_angle(lerp_cam.rotation.x,player_camera.global_rotation.x,0.25)
		lerp_cam.global_rotation.y = lerp_angle(lerp_cam.rotation.y,player_camera.global_rotation.y,0.25)
		lerp_cam.global_rotation.z = lerp_angle(lerp_cam.rotation.z,player_camera.global_rotation.z,0.25)
	
	# Hitbox Debug
	Global.p_elem_debug("# HITBOX DEBUG #")
	hitbox_debug.position = hitbox.position
	match hitbox.shape:
		BoxShape3D:
			var box_shape: BoxShape3D = hitbox.shape
			hitbox_debug.mesh = BoxMesh.new()
			var box_mesh: BoxMesh = hitbox_debug.mesh
			box_mesh.size = box_shape.size
	
	# Play walk sound
	Global.p_elem_debug("# WALK SOUND #")
	if _ground_ray_cast.is_colliding() and velocity.length() > 0 and !isSit:
		if _walk_length >= 200:
			_walk_length = 0
			if _ground_ray_cast.get_meta("SoundList","no") is Dictionary:
				var sound_list: Dictionary = _ground_ray_cast.get_meta("SoundList","no")
				var sound_player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
				get_tree().get_root().add_child(sound_player)
				sound_player.global_position = global_position
				sound_player.bus = "SFX"
				if sound_list.has(_ground_ray_cast.get_collider().get_meta("GroundMaterial","Stone")):
					sound_player.stream = sound_list.get(_ground_ray_cast.get_collider().get_meta("GroundMaterial","Stone"))
					sound_player.play()
					var _connect: Error = sound_player.connect("finished",func()->void: sound_player.queue_free())
				else:
					sound_player.queue_free()
		else:
			_walk_length += velocity.length()
	else:
		if Global.print_debug_info:
			print(_walk_length," ",_ground_ray_cast.is_colliding()," ",velocity.length())
			
	Global.p_elem_debug("### P END ###")
	
func _forward_strength(value:float) -> float:
	if (-2 * value + 1) > 0:
		return ( (-2 * value + 1) / 2 ) + 0.5
	elif (-2 * value + 1) < 0:
		return ( (-2 * value + 1) / 2 ) - 0.5
	else:
		return 0

func refresh_handheld(index:int) -> void:
	super.refresh_handheld(index)
	if index == current_hotbar:
		for n: Node in hand_held_group:
			var hitbox_shape: BoxShape3D = hitbox.shape
			if handheld_tool and handheld_tool.equipment is AHL_EToolClass:
				var tool: AHL_EToolClass = handheld_tool.equipment
				hitbox_shape.size = tool.hitbox
				hitbox.position.z = - hitbox_shape.size.z/2
				refresh_handheld_info()
			else :
				hitbox_shape.size = Vector3(0.25,0.25,1.5)
				hitbox.position.z = -0.5
				HUD_hotbar.set_info(current_hotbar)
				HUD_hotbar.set_ammo_info(false)
	if hand_held_fp.get_children():
		for i: VisualInstance3D in hand_held_fp.get_children():
			i.set_layer_mask_value(1,false)
			
func refresh_handheld_info() -> void:
	HUD_hotbar.set_info(current_hotbar,\
		handheld_tool.equipment.name0,\
		handheld_tool.equipment.icon,\
		((handheld_tool.equipment.durability - handheld_tool.damage)/handheld_tool.equipment.durability)*100)
	#if handheld_tool.equipment.send_type == "Range":
	var tool: AHL_EToolClass = handheld_tool.equipment
	HUD_hotbar.set_ammo_info(tool.send_type == "Range", tool.ammo_total)
		
func refresh_player_mesh() -> void:
	super.refresh_player_mesh()
	hand_held_group = [hand_held,hand_held_fp]
	
# Climb Detection & Teleport
func _on_climb_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("ClimbAble"):
		isClimb = true
	@warning_ignore("unsafe_property_access")
	if area.is_in_group("Teleporter") and area.get_parent().ToLocation not in ["null",""]:
		var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		var _c_tweener: CallbackTweener = tween.tween_callback(func()->void: isInTeleport=true)
		var _p_tweener: PropertyTweener = tween.tween_property(transition, "color:a", 1, 0.25)
		@warning_ignore("unsafe_property_access", "unsafe_method_access")
		_c_tweener = tween.tween_callback(func()->void: get_node("/root/World").change_scene(area.get_parent().ToLocation,area.get_parent().ToLocationPos))
		_c_tweener = tween.tween_callback(func()->void: isInTeleport=false)
		_p_tweener = tween.tween_property(transition, "color:a", 0, 0.25)
func _on_climb_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("ClimbAble"):
		isClimb = false
		for i: Area3D in _climb_area.get_overlapping_areas():
			if i.is_in_group("ClimbAble"):
				isClimb = true
# Motion Detection
func _on_motion_area_area_entered(area: MotionDetectionArea) -> void:
	area.detected_player = self
	if area.gravity_space_override != 0:
		self.gravity = area.gravity
		self.gravity_dir = area.gravity_direction
	if area.linear_damp_space_override != 0:
		self.FRICTION = area.linear_damp
func _on_motion_area_area_exited(area: MotionDetectionArea) -> void:
	area.detected_player = null
	self.gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	self.gravity_dir = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
	self.FRICTION = ProjectSettings.get_setting("physics/3d/default_linear_damp")

# Sit
func sit(chair_position : Vector3, chair_rotation : Vector3) -> void:
	var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	if !isSit :
		var _p_tweener: PropertyTweener = tween.tween_property(self, "position", chair_position, 0.5)
		_p_tweener = tween.tween_property(mesh.animation_tree,"parameters/Sit/add_amount",1,0.5)
		if !isThirdPerson:
			_p_tweener = tween.tween_property(self, "rotation:y", MathUtil.smaller_rotate(rotation.y, chair_rotation.y - deg_to_rad(180)), 0.5)
			_p_tweener = tween.tween_property(player_camera, "rotation:x", chair_rotation.x, 0.5)
		#isSit = true
	else :
		_un_sit()
func _un_sit() -> void:
	var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	var _p_tweener: PropertyTweener = tween.tween_property(mesh.animation_tree,"parameters/Sit/add_amount",0,0.5)
	isSit.remove_meta("user")
	isSit = null

# Caption
func add_caption(text_in: String) -> void:
	for i: int in caption.get_child_count():
		if caption.get_child(i) is Caption:
			var caption_i: Caption = caption.get_child(i)
			caption_i.update_pos()
	var caption_scene: PackedScene = load("res://Assets/Character/Caption/Caption.tscn")
	var new_caption: Caption = caption_scene.instantiate()
	new_caption.text = text_in
	caption.add_child(new_caption)
func clear_caption() -> void:
	for i: int in caption.get_child_count():
		if caption.get_child(i) is Caption:
			var caption_i: Caption = caption.get_child(i)
			caption_i._on_timer_timeout()
		
# HUD Hidden
func hide_hud(do_hide:bool) -> void:
	hud_hidden = do_hide
	# 不希望在游戏刚开始时就显示血量
	var state_hud_hide : bool = false
	if !self.get_meta("FullReady",true):
		state_hud_hide = true
	else:
		state_hud_hide = do_hide
	HUD_hider.play("HideHUD", -1, 1 if state_hud_hide else -1, !state_hud_hide)
	
	var tween: Tween = create_tween()
	var _p_tween: PropertyTweener = tween.tween_property($CrossHair, "modulate",
		Color(1,1,1,0) if do_hide else Color(1,1,1,1), 0.1)

func mouse_mode(isVisible:bool)->void:
	if !isThirdPerson :
		if isVisible :	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else :	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else :	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Attack
## 主要（左键）攻击。根据装备的[enum AHL_EToolClass.send_type]判断近远程类型。
## 如果是近战武器，将手持武器的伤害数据（空手伤害+武器伤害，若未持有任何武器则只发送空手伤害）发送至[method player.attack]。
## 如果是远程武器，则不发送伤害数据，而是发射子弹。
func main_attack(press: bool) -> void:
	if press == true && att_idle == true && att_sec == false:
		att_idle = false
		mesh.animation_tree["parameters/AttackStateMachine/conditions/left"] = att_order
		mesh.animation_tree["parameters/AttackStateMachine/conditions/right"] = !att_order
		att_order = !att_order
		mesh.animation_tree["parameters/MainAttack/request"] = 1
		var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		if handheld_tool:
			if handheld_tool.equipment is AHL_EToolClass:
				var tool: AHL_EToolClass = handheld_tool.equipment
				hand_held_fp.MainAttack(tool.attack_type, tool.delay)
				var _p_tween: PropertyTweener = tween.tween_property(self, "att_idle", true, 0).set_delay(tool.delay)
				match tool.send_type:
					"Melee":
						var damage_type: String = tool.damage_type
						attack(1 + tool.performance, damage_type)
					"Range":
						pass
				for i: AHL_BehaviorClass in tool.main_behavior:
					i.do(hand_held_fp.get_child(0),self)
		else:
			var _p_tween: PropertyTweener = tween.tween_property(self, "att_idle", true, 0).set_delay(0.5)
			attack(1)
## 次要（右键）攻击，预期用法和[method player.main_attack]相同但主要用于瞄准或防御，还没做。
func secondary_attack(_press:bool) -> void:
	pass
## 将从[method player.main_attack]接收到的攻击数据发送给攻击范围内的受击者。
func attack(damage_point:float, attack_type:String = "Normal") -> void:
	for i: Node3D in attack_area.get_overlapping_bodies():
		if i.get_parent() is AHL_Interactive:
			var iP: AHL_Interactive = i.get_parent()
			if iP.Hurtable:
				var damage_res: AHL_DamageResClass = AHL_DamageResClass.new()
				damage_res.sender = self
				damage_res.damage_point = damage_point
				damage_res.attack_type = attack_type
				iP.receive_attack(damage_res, self)
func receive_attack(damage_res:AHL_DamageResClass, _sender: Node) -> void:
	if current_health >= 0:
		current_health -= damage_res.damage_point
	
# Name
## 返回玩家的名字，默认为“匿名者”，如果名称为空则返回玩家节点的字符串形式。
func get_player_name() -> String:
	if player_name:
		return player_name
	else:
		return self.to_string()

# Visual
## 从给定位置移动到玩家相机的实际位置的相机动画。
func lerp_camera(pos:Vector3,rot:Vector3) -> void:
	lerp_cam_back = true
	lerp_cam.global_position = pos
	lerp_cam.global_rotation = rot
	lerp_cam.make_current()
