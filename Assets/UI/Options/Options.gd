extends TabContainer

@onready var HintButtonComment = $"#options_game#/GameSetting/VSplit/DataPath/HintButton"

@onready var GameLanguage = $"#options_game#/GameSetting/VSplit/Language/language_button"
@onready var GameLanguageRestore: Button = $"#options_game#/GameSetting/VSplit/Language/language_restore"
@onready var DataPath = $"#options_game#/GameSetting/VSplit/DataPath/datapath_button"
@onready var DataPathRestore: Button = $"#options_game#/GameSetting/VSplit/DataPath/datapath_restore"
@onready var path_choose = $"#options_game#/GameSetting/VSplit/DataPath/datapath_button/path_choose"
@onready var UseSubThreads = $"#options_game#/GameSetting/VSplit/UseSubThreads/ust_button"
@onready var UseSubThreadsRestore: Button = $"#options_game#/GameSetting/VSplit/UseSubThreads/ust_restore"
@onready var DebugOptionsGroup: Button = $"#options_game#/GameSetting/VSplit/DebugOptGroup"
@onready var DebugOptionsContainer: VBoxContainer = $"#options_game#/GameSetting/VSplit/DebugOptContainer"
@onready var PrintDebugInfo = $"#options_game#/GameSetting/VSplit/DebugOptContainer/PrintDebugInfo/pdi_button"
@onready var PrintDebugInfoRestore: Button = $"#options_game#/GameSetting/VSplit/DebugOptContainer/PrintDebugInfo/pdi_restore"
@onready var CatchPElemIssue = $"#options_game#/GameSetting/VSplit/DebugOptContainer/catchPElemIssue/cpei_button"
@onready var CatchPElemIssueRestore: Button = $"#options_game#/GameSetting/VSplit/DebugOptContainer/catchPElemIssue/cpei_restore"
@onready var AlwaysShowCursor = $"#options_game#/GameSetting/VSplit/DebugOptContainer/alwaysShowCursor/asc_button"
@onready var AlwaysShowCursorRestore: Button = $"#options_game#/GameSetting/VSplit/DebugOptContainer/alwaysShowCursor/asc_restore"

@onready var Fullscreen = $"#options_video#/VideoSetting/VSpilt/Fullscreen/fullscreen_button"
@onready var FullscreenRestore: Button = $"#options_video#/VideoSetting/VSpilt/Fullscreen/fullscreen_restore"
@onready var Scale = $"#options_video#/VideoSetting/VSpilt/Scale/scale_button"
@onready var ScaleRestore: Button = $"#options_video#/VideoSetting/VSpilt/Scale/scale_restore"
@onready var Sdfgi = $"#options_video#/VideoSetting/VSpilt/SDFGI/sdfgi_button"
@onready var SdfgiRestore: Button = $"#options_video#/VideoSetting/VSpilt/SDFGI/sdfgi_restore"

@onready var MasterVolume = $"#options_audio#/AudioSetting/VSpilt/Master/master_button"
@onready var MasterVolumeRestore: Button = $"#options_audio#/AudioSetting/VSpilt/Master/master_restore"
@onready var MasterVolumePercent = $"#options_audio#/AudioSetting/VSpilt/Master/master_percent"
@onready var BgmVolume = $"#options_audio#/AudioSetting/VSpilt/Music/bgm_button"
@onready var BgmVolumeRestore: Button = $"#options_audio#/AudioSetting/VSpilt/Music/bgm_restore"
@onready var BgmVolumePercent = $"#options_audio#/AudioSetting/VSpilt/Music/bgm_percent"
@onready var SfxVolume = $"#options_audio#/AudioSetting/VSpilt/SFX/sfx_button"
@onready var SfxVolumeRestore: Button = $"#options_audio#/AudioSetting/VSpilt/SFX/sfx_restore"
@onready var SfxVolumePercent = $"#options_audio#/AudioSetting/VSpilt/SFX/sfx_percent"

@onready var MouseSen = $"#options_control#/ControlSetting/VSpilt/MouseSen/mouse_button"
@onready var MouseSenRestore: Button = $"#options_control#/ControlSetting/VSpilt/MouseSen/mouse_restore"
@onready var MouseSenPercent = $"#options_control#/ControlSetting/VSpilt/MouseSen/mouse_percent"
@onready var AutoPickup = $"#options_control#/ControlSetting/VSpilt/AutoPickup/auto_pickup_button"
@onready var AutoPickupRestore: Button = $"#options_control#/ControlSetting/VSpilt/AutoPickup/auto_pickup_restore"
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
		GameLanguageRestore.set_disabled(is_language_match())
	elif TranslationServer.get_locale() == "en_US":
		GameLanguageRestore.set_disabled(false)
	# Data path
	DataPath.text = Global.DATA_PATH
	DataPathRestore.set_disabled(Global.DATA_PATH == "user://")
	# Use sub threads
	UseSubThreads.set_pressed_no_signal(Global.load_use_sub_threads)
	UseSubThreadsRestore.set_disabled(Global.load_use_sub_threads == false)
	# Debug
	if !DebugOptionsGroup.button_pressed:
		DebugOptionsContainer.hide()
	if !KeybindingsGroup.button_pressed:
		KeybingdingsContainer.hide()
	PrintDebugInfo.set_pressed_no_signal(Global.printDebugInfo)
	PrintDebugInfoRestore.set_disabled(Global.printDebugInfo == false)
	CatchPElemIssue.set_pressed_no_signal(Global.catchPElemIssue)
	CatchPElemIssueRestore.set_disabled(Global.catchPElemIssue == false)
	AlwaysShowCursor.set_pressed_no_signal(Global.alwaysShowCursor)
	AlwaysShowCursorRestore.set_disabled(Global.alwaysShowCursor == false)
	
	# Fullscreen
	match DisplayServer.window_get_mode():
		0:
			Fullscreen.set_pressed_no_signal(false)
			FullscreenRestore.set_disabled(true)
		3:
			Fullscreen.set_pressed_no_signal(true)
	# Scale
	Scale.value = get_window().content_scale_factor
	ScaleRestore.set_disabled(get_window().content_scale_factor == 1)
	# SDFGI
	Sdfgi.set_pressed_no_signal(Global.Sdfgi)
	SdfgiRestore.set_disabled(Global.Sdfgi == false)
	
	# Volume
	MasterVolume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	MasterVolumePercent.text = str("%.0f" %(db_to_linear(AudioServer.get_bus_volume_db(0))*100)) + "%"
	MasterVolumeRestore.set_disabled(AudioServer.get_bus_volume_db(0) == linear_to_db(1))
	BgmVolume.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	BgmVolumePercent.text = str("%.0f" %(db_to_linear(AudioServer.get_bus_volume_db(1))*100)) + "%"
	BgmVolumeRestore.set_disabled(AudioServer.get_bus_volume_db(1) == linear_to_db(1))
	SfxVolume.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	SfxVolumePercent.text = str("%.0f" %(db_to_linear(AudioServer.get_bus_volume_db(2))*100)) + "%"
	SfxVolumeRestore.set_disabled(AudioServer.get_bus_volume_db(2) == linear_to_db(1))
	
	# Control
	MouseSen.value = Global.mouse_sens
	MouseSenPercent.text = str("%.0f" %((Global.mouse_sens)*100)) + "%"
	MouseSenRestore.set_disabled(Global.mouse_sens == 0.4)
	# AutoPickup
	AutoPickup.set_pressed_no_signal(Global.auto_pickup)
	AutoPickupRestore.set_disabled(Global.auto_pickup == true)

# Change tab
func _input(_event):
	if Global.current_menu == "Options":
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
	GameLanguageRestore.set_disabled(is_language_match() or (!Global.is_os_language_supported() and index == 0))
	Global.save_settings_to_file("game","language",TranslationServer.get_locale())
	Global.window_min_limit()
func is_language_match() -> bool:
	return TranslationServer.get_locale() == OS.get_locale()
func _on_language_restore_pressed() -> void:
	if Global.is_os_language_supported():
		GameLanguage.select(Global.LanguageList.find(OS.get_locale()))
		_on_language_button_item_selected(Global.LanguageList.find(OS.get_locale()))
	else:
		GameLanguage.select(0)
		_on_language_button_item_selected(0)
# Choose data path
func _on_datapath_button_pressed():
	path_choose.set_current_dir(Global.DATA_PATH)
	path_choose.show()
func _on_path_choose_dir_selected(dir):
	Global.DATA_PATH = dir
	DataPath.text = dir
	Global.save_settings_to_file("game","data_path",dir)
	DataPathRestore.set_disabled(Global.DATA_PATH == "user://")
func _on_datapath_restore_pressed() -> void:
	DataPathRestore.set_disabled(true)
	Global.DATA_PATH = "user://"
	DataPath.text = "user://"
	Global.save_settings_to_file("game","data_path","user://")
# Use sub threads to load scene
func _on_ust_button_toggled(toggled_on):
	Global.load_use_sub_threads = toggled_on
	Global.save_settings_to_file("game","load_use_sub_threads",toggled_on)
	UseSubThreadsRestore.set_disabled(Global.load_use_sub_threads == false)
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
	PrintDebugInfoRestore.set_disabled(Global.printDebugInfo == false)
func _on_pdi_restore_pressed() -> void:
	PrintDebugInfo.set_pressed(false)
func _on_cpei_button_toggled(toggled_on):
	Global.catchPElemIssue = toggled_on
	Global.save_settings_to_file("game","catch_p_null_issue",toggled_on)
	CatchPElemIssueRestore.set_disabled(Global.catchPElemIssue == false)
func _on_cpei_restore_pressed() -> void:
	CatchPElemIssue.set_pressed(false)
func _on_asc_button_toggled(toggled_on):
	Global.alwaysShowCursor = toggled_on
	Global.save_settings_to_file("game","always_show_cursor",toggled_on)
	AlwaysShowCursorRestore.set_disabled(Global.alwaysShowCursor == false)
func _on_asc_restore_pressed() -> void:
	AlwaysShowCursor.set_pressed(false)
	
func _key_debug_scene() -> void:
	AHL_LoadManager.load_scene("res://Title/debug/KeyDebug.tscn")

# Fullscreen
func _on_fullscreen_button_toggled(toggled_on):
	if toggled_on == true :
		if DisplayServer.window_get_mode() != 2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else :
		while DisplayServer.window_get_mode() != 0:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2(1600,900))
	Global.save_settings_to_file("video","fullscreen",DisplayServer.window_get_mode())
	FullscreenRestore.set_disabled(DisplayServer.window_get_mode() == 0)
func _on_fullscreen_restore_pressed() -> void:
	Fullscreen.set_pressed(false)
# Scale
func _on_scale_button_value_changed(value):
	get_window().content_scale_factor = value
	Global.save_settings_to_file("video","scale",get_window().content_scale_factor)
	ScaleRestore.set_disabled(get_window().content_scale_factor == 1)
func _on_scale_restore_pressed() -> void:
	Scale.set_value(1)
# SDFGI
func _on_sdfgi_button_toggled(toggled_on):
	Global.Sdfgi = toggled_on
	SetSdfgi.emit(toggled_on)
	Global.save_settings_to_file("video","sdfgi",toggled_on)
	SdfgiRestore.set_disabled(Global.Sdfgi == false)
func _on_sdfgi_restore_pressed() -> void:
	Sdfgi.set_pressed(false)
	
# Master volume
func _on_master_button_value_changed(value):
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
	MasterVolumePercent.text = str("%.0f" %(value*100)) + "%"
	Global.save_settings_to_file("audio","master",AudioServer.get_bus_volume_db(0))
	MasterVolumeRestore.set_disabled(AudioServer.get_bus_volume_db(0) == linear_to_db(1))
func _on_master_restore_pressed() -> void:
	MasterVolume.set_value(1)
# Bgm volume
func _on_bgm_button_value_changed(value):
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	BgmVolumePercent.text = str("%.0f" %(value*100)) + "%"
	Global.save_settings_to_file("audio","bgm",AudioServer.get_bus_volume_db(1))
	BgmVolumeRestore.set_disabled(AudioServer.get_bus_volume_db(1) == linear_to_db(1))
func _on_bgm_restore_pressed() -> void:
	BgmVolume.set_value(1)
# Sfx volume
func _on_sfx_button_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	SfxVolumePercent.text = str("%.0f" %(value*100)) + "%"
	Global.save_settings_to_file("audio","sfx",AudioServer.get_bus_volume_db(2))
	SfxVolumeRestore.set_disabled(AudioServer.get_bus_volume_db(2) == linear_to_db(1))
func _on_sfx_restore_pressed() -> void:
	SfxVolume.set_value(1)
	
# Mouse sensitivity
func _on_mouse_button_value_changed(value):
	Global.mouse_sens = value
	MouseSenPercent.text = str("%.0f" %(value*100)) + "%"
	Global.save_settings_to_file("control","mouse_sens",value)
	MouseSenRestore.set_disabled(Global.mouse_sens == 0.4)
func _on_mouse_restore_pressed() -> void:
	MouseSen.set_value(0.4)
# AutoPickup
func _on_auto_pickup_button_toggled(toggled_on):
	Global.auto_pickup = toggled_on
	Global.save_settings_to_file("control","auto_pickup",toggled_on)
	AutoPickupRestore.set_disabled(Global.auto_pickup == true)
func _on_auto_pickup_restore_pressed() -> void:
	AutoPickup.set_pressed(true)
# Keybindings
func _on_keybindings_group_toggled(toggled_on: bool) -> void:
	if toggled_on:
		KeybingdingsContainer.show()
	else:
		KeybingdingsContainer.hide()

func _on_tab_changed(_tab):
	if Global.current_menu == "Options":
		tab_focus()
func tab_focus():
	match current_tab:
		0:GameLanguage.grab_focus()
		1:Fullscreen.grab_focus()
		2:MasterVolume.grab_focus()
		3:MouseSen.grab_focus()
