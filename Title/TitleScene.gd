extends Control
var current_menu : String = "Ready"

@onready var animation = $AnimationPlayer
@onready var timer = $Main/HBoxContainer/Timer

func _input(event):
	if current_menu == "Ready" and (event is InputEventKey or event is InputEventMouseButton):
		animation.play("ToMainMenu")
		current_menu = "Main"
	timer.start()
		
func _on_timer_timeout():
	if current_menu == "Main":
		animation.play_backwards("ToMainMenu")
		current_menu = "Ready"

#Options
func _on_options_button_pressed():
	if current_menu == "Main" and !animation.is_playing():
		animation.play("Options")
		current_menu = "Options"
func _on_options_back_button_pressed():
	if current_menu == "Options":
		animation.play_backwards("Options")
		current_menu = "Main"

#Exit
func _on_exit_button_pressed():
	if current_menu == "Main" and !animation.is_playing():
		animation.play("Exit")
		current_menu = "Exit"
func _on_cancel_button_pressed():
	if current_menu == "Exit":
		animation.play_backwards("Exit")
		current_menu = "Main"
func _on_confirm_button_pressed():
	if current_menu == "Exit":	get_tree().quit()

#World
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Assets_Main/World/WorldMain.tscn")
