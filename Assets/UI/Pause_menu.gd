extends ColorRect

var escape_released = false
@onready var animation = $AnimationPlayer
@onready var exit_button = $Main/ExitButton
@onready var exit_text1 = $ExitBox/exit_text1
@onready var multi_player_list: Tree = $MultiPlayerList

@onready var options: TabContainer = $Options

signal mouse_mode_signal(bool)

func _ready():
	#Global.current_menu = "Pause" # Don't know why I write this...
	animation.play("RESET")
	if get_parent().isInDream :
		exit_button.text = "pause.quit"
		exit_text1.text = "exit.quit_vr"

func _on_visibility_changed():
	get_tree().paused = visible
	if multi_player_list:
		refresh_multiplayer_list()

func _unhandled_input(_event):
	if Input.is_action_just_released("ui_cancel") :
		if escape_released == false and is_visible_in_tree():
			escape_released = true
		elif Global.current_menu == "Pause":
			escape_released = false
			_on_resume_button_pressed()
func _on_resume_button_pressed():
	mouse_mode_signal.emit(false)
	get_parent().current_menu = "HUD"
	Global.current_menu = "Main"
	hide()
	
func refresh_multiplayer_list():
	multi_player_list.visible = Global.isMultiplayer
	multi_player_list.clear()
	for i in multiplayer.get_peers():
		var player_name: TreeItem = multi_player_list.create_item()
		player_name.set_text(0,str(i))
	
func _on_options_button_pressed():
	Global.current_menu = "Options"
	escape_released = false
	animation.play("Options")
	options._ready()
func _on_back_button_pressed():
	if Global.current_menu == "Options" and !AHL_NoticeManager.is_notice_show and !Global.block_escape:
		Global.current_menu = "Pause"
		animation.play_backwards("Options")
	
func _on_exit_button_pressed():
	Global.current_menu = "Exit"
	escape_released = false
	animation.play("Exit")
func _on_confirm_button_pressed():
	hide()
	if !get_parent().isInDream :
		Global.back_to_title()
	else :
		AHL_LoadManager.load_scene("res://Assets/World/WorldMain.tscn",
			true, Vector3(-5.5,0,5.5), true, Vector3(0,deg_to_rad(180),0))
		get_parent().isInDream = false
func _on_cancel_button_pressed():
	if Global.current_menu == "Exit":
		Global.current_menu = "Pause"
		animation.play_backwards("Exit")
