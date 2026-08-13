extends ColorRect

var escape_released: bool = false
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var wakeup_button: Button = $Main/WakeupButton
@onready var multi_player_list: Tree = $MultiPlayerList

@onready var options: TabContainer = $Options

signal mouse_mode_signal(value: bool)

func _ready() -> void:
	#Global.current_menu = "Pause" # Don't know why I write this...
	animation.play("RESET")

func _on_visibility_changed() -> void:
	get_tree().paused = visible
	if multi_player_list:
		refresh_multiplayer_list()
	if wakeup_button:
		wakeup_button.visible = get_user().isInDream

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("ui_cancel") :
		if escape_released == false and is_visible_in_tree():
			escape_released = true
		elif Global.current_menu == "Pause":
			escape_released = false
			_on_resume_button_pressed()
func _on_resume_button_pressed() -> void:
	mouse_mode_signal.emit(false)
	get_user().current_menu = "HUD"
	Global.current_menu = "Main"
	hide()
	
func refresh_multiplayer_list() -> void:
	multi_player_list.visible = Global.is_multiplayer
	multi_player_list.clear()
	for i: int in multiplayer.get_peers():
		var player_name: TreeItem = multi_player_list.create_item()
		player_name.set_text(0,str(i))
	
func _on_options_button_pressed() -> void:
	Global.current_menu = "Options"
	escape_released = false
	animation.play("Options")
	options._ready()
func _on_back_button_pressed() -> void:
	if Global.current_menu == "Options" and !AHL_Core.is_notice_shown and !Global.block_escape:
		Global.current_menu = "Pause"
		animation.play_backwards("Options")
	
func _on_exit_button_pressed() -> void:
	Global.current_menu = "Exit"
	escape_released = false
	animation.play("Exit")
func _on_confirm_button_pressed() -> void:
	hide()
	Global.back_to_title()
func _on_cancel_button_pressed() -> void:
	if Global.current_menu == "Exit":
		Global.current_menu = "Pause"
		animation.play_backwards("Exit")

func get_user() -> LocalPlayer:
	return get_parent()


func _on_wakeup_button_pressed() -> void:
	hide()
	AHL_LoadingScene.new_loader("res://assets/world/world_main.tscn")\
			.to_pos(Vector3(-5.5,0,5.5)).to_rot(Vector3(0,deg_to_rad(180),0))\
			.start_load()
	get_user().isInDream = false
