extends TabContainer

@onready var GameLanguage = $"#options_game#/GameSetting/VSplit/Language/language_button"
@onready var DataPath = $"#options_game#/GameSetting/VSplit/DataPath/datapath_button"
@onready var path_choose = $"#options_game#/GameSetting/VSplit/DataPath/datapath_button/path_choose"
@onready var UseSubThreads = $"#options_game#/GameSetting/VSplit/UseSubThreads/ust_button"
@onready var PrintDebugInfoHOS = $"#options_game#/GameSetting/VSplit/PrintDebugInfo"
@onready var DebugOptionsGroup: Button = $"#options_game#/GameSetting/VSplit/DebugOptGroup"
@onready var PrintDebugInfo = $"#options_game#/GameSetting/VSplit/PrintDebugInfo/pdi_button"
@onready var CatchPElemIssueHOS = $"#options_game#/GameSetting/VSplit/catchPElemIssue"
@onready var CatchPElemIssue = $"#options_game#/GameSetting/VSplit/catchPElemIssue/cpei_button"

@onready var Fullscreen = $"#options_video#/VideoSetting/VSpilt/Fullscreen/fullscreen_button"
@onready var fullscreen_warn = $"#options_video#/VideoSetting/VSpilt/Fullscreen/fullscreen_button/fullscreen_warn"
@onready var Scale = $"#options_video#/VideoSetting/VSpilt/Scale/scale_button"
@onready var Sdfgi = $"#options_video#/VideoSetting/VSpilt/SDFGI/sdfgi_button"

@onready var MasterVolume = $"#options_audio#/AudioSetting/VSpilt/Master/master_button"
@onready var BgmVolume = $"#options_audio#/AudioSetting/VSpilt/Music/bgm_button"
@onready var SfxVolume = $"#options_audio#/AudioSetting/VSpilt/SFX/sfx_button"

@onready var MouseSen = $"#options_control#/ControlSetting/VSpilt/MouseSen/mouse_button"
@onready var AutoPickup = $"#options_control#/ControlSetting/VSpilt/AutoPickup/auto_pickup_button"

signal SetSdfgi(bool)

func _ready():
	# Language
	match TranslationServer.get_locale():
		"en_US":	GameLanguage.set_indexed("selected",0)
		"zh_CN":	GameLanguage.set_indexed("selected",1)
	# Data path
	DataPath.text = Global.DATA_PATH
	# Use sub threads
	UseSubThreads.set_pressed_no_signal(Global.load_use_sub_threads)
	# Debug
	if !DebugOptionsGroup.button_pressed:
		PrintDebugInfoHOS.hide()
		CatchPElemIssueHOS.hide()
	PrintDebugInfo.set_pressed_no_signal(Global.printDebugInfo)
	CatchPElemIssue.set_pressed_no_signal(Global.catchPElemIssue)
	
	# Fullscreen
	match DisplayServer.window_get_mode():
		0:	Fullscreen.set_pressed_no_signal(false)
		3:	Fullscreen.set_pressed_no_signal(true)
	# Scale
	Scale.value = get_window().content_scale_factor
	# SDFGI
	Sdfgi.set_pressed_no_signal(Global.Sdfgi)
	# Volume
	MasterVolume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	MasterVolume.set_tooltip_text( str(db_to_linear(AudioServer.get_bus_volume_db(0))*100) + "%")
	BgmVolume.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	BgmVolume.set_tooltip_text( str(db_to_linear(AudioServer.get_bus_volume_db(1))*100) + "%")
	SfxVolume.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	SfxVolume.set_tooltip_text( str(db_to_linear(AudioServer.get_bus_volume_db(2))*100) + "%")
	# Control
	MouseSen.value = Global.mouse_sens
	MouseSen.set_tooltip_text( str((Global.mouse_sens)*100) + "%")
	# AutoPickup
	AutoPickup.set_pressed_no_signal(Global.auto_pickup)
	

# Change tab
func _input(_event):
	if get_parent().has_method("get_current_menu") and get_parent().get_current_menu() == "Options":
		if Input.is_action_just_pressed("tab_right"):
			if current_tab == get_tab_count()-1 :	current_tab = 0
			else :									current_tab += 1
			tab_focus()
		if Input.is_action_just_pressed("tab_left"):
			if current_tab == 0 :	current_tab = get_tab_count()-1
			else :					current_tab -= 1
			tab_focus()
# Language
func _on_option_button_item_selected(index):
	match index:
		0:	TranslationServer.set_locale("en_US")
		1:	TranslationServer.set_locale("zh_CN")
	Global.save_config()
	Global.window_min_limit()
# Choose data path
func _on_datapath_button_pressed():
	path_choose.show()
func _on_path_choose_dir_selected(dir):
	Global.DATA_PATH = dir
	DataPath.text = Global.DATA_PATH
	Global.save_config()
# Use sub threads to load scene
func _on_ust_button_toggled(toggled_on):
	Global.load_use_sub_threads = toggled_on
	Global.save_config()
# Debug
func _on_debug_opt_group_toggled(toggled_on: bool) -> void:
	if toggled_on:
		PrintDebugInfoHOS.show()
		CatchPElemIssueHOS.show()
	else:
		PrintDebugInfoHOS.hide()
		CatchPElemIssueHOS.hide()
func _on_pdi_button_toggled(toggled_on):
	Global.printDebugInfo = toggled_on
	Global.save_config()
func _on_cpei_button_toggled(toggled_on):
	Global.catchPElemIssue = toggled_on
	Global.save_config()

# Fullscreen
func _on_fullscreen_button_toggled(toggled_on):
	if toggled_on == true :
		if DisplayServer.window_get_mode() != 2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else :	fullscreen_warn.show()
	else :
		while DisplayServer.window_get_mode() != 0:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2(1600,900))
	Global.save_config()
func _on_fullscreen_warn_close_requested():
	await get_tree().create_timer(0.0001).timeout
	fullscreen_warn.show()
# Scale
func _on_scale_button_value_changed(value):
	get_window().content_scale_factor = value
	Global.save_config()
# SDFGI
func _on_sdfgi_button_toggled(toggled_on):
	Global.Sdfgi = toggled_on
	SetSdfgi.emit(toggled_on)
	Global.save_config()
	
#Master volume
func _on_master_button_value_changed(value):
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
	MasterVolume.set_tooltip_text( str(value*100) + "%")
	Global.save_config()
#Bgm volume
func _on_bgm_button_value_changed(value):
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	BgmVolume.set_tooltip_text( str(value*100) + "%")
	Global.save_config()
#Sfx volume
func _on_sfx_button_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	SfxVolume.set_tooltip_text( str(value*100) + "%")
	Global.save_config()
	
#Mouse sensitivity
func _on_mouse_button_value_changed(value):
	Global.mouse_sens = value
	MouseSen.set_tooltip_text( str(value*100) + "%")
	Global.save_config()
#AutoPickup
func _on_auto_pickup_button_toggled(toggled_on):
	Global.auto_pickup = toggled_on
	Global.save_config()

func _on_tab_changed(_tab):
	tab_focus()
func tab_focus():
	match current_tab:
		0:GameLanguage.grab_focus()
		1:Fullscreen.grab_focus()
		2:MasterVolume.grab_focus()
		3:MouseSen.grab_focus()
