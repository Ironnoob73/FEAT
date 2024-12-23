extends Control
var current_menu : String = "Ready"

@onready var animation = $AnimationPlayer
@onready var timer = $Main/HBoxContainer/Timer

#@onready var tooltip = $DynamicTooltip

func _input(event):
	if current_menu == "Ready" and (event is InputEventKey or event is InputEventMouseButton):
		animation.play("ToMainMenu")
		current_menu = "Main"
	timer.start()
		
func _on_timer_timeout():
	if current_menu == "Main":
		animation.play_backwards("ToMainMenu")
		current_menu = "Ready"

# Options
func _on_options_button_pressed():
	if current_menu == "Main" and !animation.is_playing():
		animation.play("Options")
		current_menu = "Options"
func _on_options_back_button_pressed():
	if current_menu == "Options":
		animation.play_backwards("Options")
		current_menu = "Main"

# Exit
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

# World
func _on_start_button_pressed():
	LoadManager.load_scene("res://Assets_Main/World/WorldMain.tscn")
	Global.isInGame = true

# Uncomplete
func _on_continue_button_pressed():
	NoticeManager.show_notice(load("res://Assets_Main/UI/Notice/notice_info_test.tres"))
	
# Unused TTS
	# One-time steps.
	# Pick a voice. Here, we arbitrarily pick the first English voice.
	#var voices = DisplayServer.tts_get_voices_for_language("zh")
	#var voice_id = voices[0]

	# Say "Hello, world!".
	#DisplayServer.tts_speak("Hello, world!", voice_id)

	#DisplayServer.tts_stop()
	#DisplayServer.tts_speak("Goodbye!", voice_id)

# Tooltip
#func _process(_delta):
#	tooltip.position = lerp(Vector2(tooltip.position),get_global_mouse_position() + Vector2(20,20),0.5)
