extends ColorRect

var escape_released = false
@onready var animation = $AnimationPlayer
@onready var exit_button = $Main/ExitButton
@onready var exit_text1 = $ExitBox/exit_text1

signal mouse_mode_signal(bool)

func _ready():
	Global.current_menu = "Pause"
	animation.play("RESET")
	if get_parent().isInVR :
		exit_button.text = "pause.quit"
		exit_text1.text = "exit.quit_vr"

func _on_visibility_changed():
	get_tree().paused = visible

func _unhandled_input(_event):
	if Input.is_action_just_released("ui_cancel") :
		if escape_released == false :
			escape_released = true
		elif Global.current_menu == "Pause":
			escape_released = false
			_on_resume_button_pressed()
func _on_resume_button_pressed():
	mouse_mode_signal.emit(false)
	get_parent().current_menu = "HUD"
	hide()
	
func _on_options_button_pressed():
	Global.current_menu = "Options"
	escape_released = false
	animation.play("Options")
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
	if !get_parent().isInVR :	Global.back_to_title()
	else :
		AHL_LoadManager.load_scene(Global.get_world_path(Global.VRDim),Global.VRPos,Global.VRRot)
func _on_cancel_button_pressed():
	if Global.current_menu == "Exit":
		Global.current_menu = "Pause"
		animation.play_backwards("Exit")
