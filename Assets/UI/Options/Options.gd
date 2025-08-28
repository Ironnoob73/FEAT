extends TabContainer

@onready var HintButtonComment = $"#options_game#/GameSetting/VSplit/DataPath/HintButton"

@onready var GameLanguage = $"#options_game#/GameSetting/VSplit/Language/language_button"
@onready var GameLanguageRB: Button = $"#options_game#/GameSetting/VSplit/Language/language_restore"
@onready var DataPath = $"#options_game#/GameSetting/VSplit/DataPath/datapath_button"
@onready var DataPathRB: Button = $"#options_game#/GameSetting/VSplit/DataPath/datapath_restore"
@onready var path_choose = $"#options_game#/GameSetting/VSplit/DataPath/datapath_button/path_choose"
@onready var UseSubThreads = $"#options_game#/GameSetting/VSplit/UseSubThreads/ust_button"
@onready var UseSubThreadsRB: Button = $"#options_game#/GameSetting/VSplit/UseSubThreads/ust_restore"
@onready var DebugOptionsGroup: Button = $"#options_game#/GameSetting/VSplit/DebugOptGroup"
@onready var DebugOptionsContainer: VBoxContainer = $"#options_game#/GameSetting/VSplit/DebugOptContainer"
@onready var PrintDebugInfo = $"#options_game#/GameSetting/VSplit/DebugOptContainer/PrintDebugInfo/pdi_button"
@onready var PrintDebugInfoRB: Button = $"#options_game#/GameSetting/VSplit/DebugOptContainer/PrintDebugInfo/pdi_restore"
@onready var CatchPElemIssue = $"#options_game#/GameSetting/VSplit/DebugOptContainer/catchPElemIssue/cpei_button"
@onready var CatchPElemIssueRB: Button = $"#options_game#/GameSetting/VSplit/DebugOptContainer/catchPElemIssue/cpei_restore"
@onready var AlwaysShowCursor = $"#options_game#/GameSetting/VSplit/DebugOptContainer/alwaysShowCursor/asc_button"
@onready var AlwaysShowCursorRB: Button = $"#options_game#/GameSetting/VSplit/DebugOptContainer/alwaysShowCursor/asc_restore"

@onready var Fullscreen = $"#options_video#/VideoSetting/VSpilt/Fullscreen/fullscreen_button"
@onready var fullscreen_warn = $"#options_video#/VideoSetting/VSpilt/Fullscreen/fullscreen_button/fullscreen_warn"
@onready var Scale = $"#options_video#/VideoSetting/VSpilt/Scale/scale_button"
@onready var Sdfgi = $"#options_video#/VideoSetting/VSpilt/SDFGI/sdfgi_button"

@onready var MasterVolume = $"#options_audio#/AudioSetting/VSpilt/Master/master_button"
@onready var MasterVolumePercent = $"#options_audio#/AudioSetting/VSpilt/Master/percent"
@onready var BgmVolume = $"#options_audio#/AudioSetting/VSpilt/Music/bgm_button"
@onready var BgmVolumePercent = $"#options_audio#/AudioSetting/VSpilt/Music/percent"
@onready var SfxVolume = $"#options_audio#/AudioSetting/VSpilt/SFX/sfx_button"
@onready var SfxVolumePercent = $"#options_audio#/AudioSetting/VSpilt/SFX/percent"

@onready var MouseSen = $"#options_control#/ControlSetting/VSpilt/MouseSen/mouse_button"
@onready var MouseSenPercent = $"#options_control#/ControlSetting/VSpilt/MouseSen/percent"
@onready var AutoPickup = $"#options_control#/ControlSetting/VSpilt/AutoPickup/auto_pickup_button"
@onready var KeybindingsGroup: Button = $"#options_control#/ControlSetting/VSpilt/KeybindingsGroup"
@onready var KeybingdingsContainer: VBoxContainer = $"#options_control#/ControlSetting/VSpilt/KeybindingsContainer"

signal SetSdfgi(bool)

func _ready():
	HintButtonComment.text = ""
	# Language
	match TranslationServer.get_locale():
		"en_US":	GameLanguage.set_indexed("selected",0)
		"zh_CN":	GameLanguage.set_indexed("selected",1)
	if Global.is_os_language_supported():
		GameLanguageRB.set_disabled(is_language_match())
	# Data path
	DataPath.text = Global.DATA_PATH
	DataPathRB.set_disabled(Global.DATA_PATH == "user://")
	# Use sub threads
	UseSubThreads.set_pressed_no_signal(Global.load_use_sub_threads)
	UseSubThreadsRB.set_disabled(Global.load_use_sub_threads == false)
	# Debug
	if !DebugOptionsGroup.button_pressed:
		DebugOptionsContainer.hide()
	if !KeybindingsGroup.button_pressed:
		KeybingdingsContainer.hide()
	PrintDebugInfo.set_pressed_no_signal(Global.printDebugInfo)
	PrintDebugInfoRB.set_disabled(Global.printDebugInfo == false)
	CatchPElemIssue.set_pressed_no_signal(Global.catchPElemIssue)
	CatchPElemIssueRB.set_disabled(Global.catchPElemIssue == false)
	AlwaysShowCursor.set_pressed_no_signal(Global.alwaysShowCursor)
	AlwaysShowCursorRB.set_disabled(Global.alwaysShowCursor == false)
	
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
	MasterVolumePercent.text = str(db_to_linear(AudioServer.get_bus_volume_db(0))*100) + "%"
	BgmVolume.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	BgmVolumePercent.text = str(db_to_linear(AudioServer.get_bus_volume_db(1))*100) + "%"
	SfxVolume.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	SfxVolumePercent.text = str(db_to_linear(AudioServer.get_bus_volume_db(2))*100) + "%"
	# Control
	MouseSen.value = Global.mouse_sens
	MouseSenPercent.text = str((Global.mouse_sens)*100) + "%"
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
func _on_language_button_item_selected(index: int) -> void:
	match index:
		0:	TranslationServer.set_locale("en_US")
		1:	TranslationServer.set_locale("zh_CN")
	GameLanguageRB.set_disabled(is_language_match() or index == 0)
	Global.save_settings_to_file("game","language",TranslationServer.get_locale())
	Global.window_min_limit()
func is_language_match() -> bool:
	return TranslationServer.get_locale() == OS.get_locale()
func _on_language_restore_pressed() -> void:
	if Global.is_os_language_supported():
		GameLanguage.select(Global.LanguageList.find(OS.get_locale()))
	else:
		GameLanguage.select(0)
# Choose data path
func _on_datapath_button_pressed():
	path_choose.set_current_dir(Global.DATA_PATH)
	path_choose.show()
func _on_path_choose_dir_selected(dir):
	Global.DATA_PATH = dir
	DataPath.text = dir
	Global.save_settings_to_file("game","data_path",dir)
	DataPathRB.set_disabled(Global.DATA_PATH == "user://")
func _on_datapath_restore_pressed() -> void:
	DataPathRB.set_disabled(true)
	Global.DATA_PATH = "user://"
	DataPath.text = "user://"
	Global.save_settings_to_file("game","data_path","user://")
# Use sub threads to load scene
func _on_ust_button_toggled(toggled_on):
	Global.load_use_sub_threads = toggled_on
	Global.save_settings_to_file("game","load_use_sub_threads",toggled_on)
	UseSubThreadsRB.set_disabled(Global.load_use_sub_threads == false)
func _on_ust_restore_pressed() -> void:
	UseSubThreads.set_pressed(false)
# Debug
func _on_debug_opt_group_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DebugOptionsContainer.show()
	else:
		DebugOptionsContainer.hide()
func _on_pdi_button_toggled(toggled_on):
	Global.printDebugInfo = toggled_on
	Global.save_settings_to_file("game","print_debug_info",toggled_on)
	PrintDebugInfoRB.set_disabled(Global.printDebugInfo == false)
func _on_pdi_restore_pressed() -> void:
	PrintDebugInfo.set_pressed(false)
func _on_cpei_button_toggled(toggled_on):
	Global.catchPElemIssue = toggled_on
	Global.save_settings_to_file("game","catch_p_null_issue",toggled_on)
	CatchPElemIssueRB.set_disabled(Global.catchPElemIssue == false)
func _on_cpei_restore_pressed() -> void:
	CatchPElemIssue.set_pressed(false)
func _on_asc_button_toggled(toggled_on):
	Global.alwaysShowCursor = toggled_on
	Global.save_settings_to_file("game","always_show_cursor",toggled_on)
	AlwaysShowCursorRB.set_disabled(Global.alwaysShowCursor == false)
func _on_asc_restore_pressed() -> void:
	AlwaysShowCursor.set_pressed(false)
	
func _key_debug_scene() -> void:
	AHL_LoadManager.load_scene("res://Title/debug/KeyDebug.tscn")

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
	Global.save_settings_to_file("video","fullscreen",DisplayServer.window_get_mode())
func _on_fullscreen_warn_close_requested():
	await get_tree().create_timer(0.0001).timeout
	fullscreen_warn.show()
# Scale
func _on_scale_button_value_changed(value):
	get_window().content_scale_factor = value
	Global.save_settings_to_file("video","scale",get_window().content_scale_factor)
# SDFGI
func _on_sdfgi_button_toggled(toggled_on):
	Global.Sdfgi = toggled_on
	SetSdfgi.emit(toggled_on)
	Global.save_settings_to_file("video","sdfgi",toggled_on)
	
# Master volume
func _on_master_button_value_changed(value):
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
	MasterVolumePercent.text = str(value*100) + "%"
	Global.save_settings_to_file("audio","master",AudioServer.get_bus_volume_db(0))
# Bgm volume
func _on_bgm_button_value_changed(value):
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	BgmVolumePercent.text = str(value*100) + "%"
	Global.save_settings_to_file("audio","bgm",AudioServer.get_bus_volume_db(1))
# Sfx volume
func _on_sfx_button_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	SfxVolumePercent.text = str(value*100) + "%"
	Global.save_settings_to_file("audio","sfx",AudioServer.get_bus_volume_db(2))
	
# Mouse sensitivity
func _on_mouse_button_value_changed(value):
	Global.mouse_sens = value
	MouseSenPercent.text = str(value*100) + "%"
	Global.save_settings_to_file("control","mouse_sens",value)
# AutoPickup
func _on_auto_pickup_button_toggled(toggled_on):
	Global.auto_pickup = toggled_on
	Global.save_settings_to_file("control","auto_pickup",toggled_on)
# Keybindings
func _on_keybindings_group_toggled(toggled_on: bool) -> void:
	if toggled_on:
		KeybingdingsContainer.show()
	else:
		KeybingdingsContainer.hide()

func _on_tab_changed(_tab):
	tab_focus()
func tab_focus():
	match current_tab:
		0:GameLanguage.grab_focus()
		1:Fullscreen.grab_focus()
		2:MasterVolume.grab_focus()
		3:MouseSen.grab_focus()
