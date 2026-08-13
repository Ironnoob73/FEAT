extends TabContainer

@onready var hint_button_comment: Button = $"GameOptions/GameSetting/VSplit/DataPath/HintButton"

@onready var game_language: OptionButton = $"GameOptions/GameSetting/VSplit/Language/LanguageButton"
@onready var game_language_restore: Button = $"GameOptions/GameSetting/VSplit/Language/LanguageRestore"
@onready var data_path: Button = $"GameOptions/GameSetting/VSplit/DataPath/DatapathButton"
@onready var data_path_restore: Button = $"GameOptions/GameSetting/VSplit/DataPath/DatapathRestore"
@onready var path_choose: FileDialog = $"GameOptions/GameSetting/VSplit/DataPath/DatapathButton/PathChoose"
@onready var use_sub_threads: CheckBox = $"GameOptions/GameSetting/VSplit/UseSubThreads/UstCheckbox"
@onready var use_sub_threadsRestore: Button = $"GameOptions/GameSetting/VSplit/UseSubThreads/UstRestore"
@onready var debug_options_group: Button = $"GameOptions/GameSetting/VSplit/DebugOptGroup"
@onready var debug_options_container: VBoxContainer = $"GameOptions/GameSetting/VSplit/DebugOptContainer"
@onready var print_debug_info: CheckBox = $"GameOptions/GameSetting/VSplit/DebugOptContainer/PrintDebugInfo/PdiCheckbox"
@onready var print_debug_info_restore: Button = $"GameOptions/GameSetting/VSplit/DebugOptContainer/PrintDebugInfo/PdiRestore"
@onready var catch_p_elem_issue: CheckBox = $"GameOptions/GameSetting/VSplit/DebugOptContainer/CatchPElemIssue/CpeiCheckbox"
@onready var catch_p_elem_issue_restore: Button = $"GameOptions/GameSetting/VSplit/DebugOptContainer/CatchPElemIssue/CpeiRestore"
@onready var always_show_cursor: CheckBox = $"GameOptions/GameSetting/VSplit/DebugOptContainer/AlwaysShowCursor/AscCheckbox"
@onready var always_show_cursor_restore: Button = $"GameOptions/GameSetting/VSplit/DebugOptContainer/AlwaysShowCursor/AscRestore"
@onready var fast_boot: CheckBox = $"GameOptions/GameSetting/VSplit/DebugOptContainer/FastBoot/FbCheckbox"
@onready var fast_boot_restore: Button = $"GameOptions/GameSetting/VSplit/DebugOptContainer/FastBoot/FbRestore"
@onready var oobe: CheckBox = $"GameOptions/GameSetting/VSplit/DebugOptContainer/OOBE/OobeCheckbox"
@onready var oobe_restore: Button = $"GameOptions/GameSetting/VSplit/DebugOptContainer/OOBE/OobeRestore"

@onready var fullscreen: CheckBox = $"VideoOptions/VideoSetting/VSpilt/Fullscreen/FullscreenCheckbox"
@onready var fullscreen_restore: Button = $"VideoOptions/VideoSetting/VSpilt/Fullscreen/FullscreenRestore"
@onready var interface_scale: SpinBox = $"VideoOptions/VideoSetting/VSpilt/Scale/ScaleSpin"
@onready var interface_scale_restore: Button = $"VideoOptions/VideoSetting/VSpilt/Scale/ScaleRestore"
@onready var sdfgi: CheckBox = $"VideoOptions/VideoSetting/VSpilt/SDFGI/SdfgiCheckbox"
@onready var sdfgi_restore: Button = $"VideoOptions/VideoSetting/VSpilt/SDFGI/SdfgiRestore"

@onready var master_volume: HSlider = $"AudioOptions/AudioSetting/VSpilt/Master/MasterSlider"
@onready var master_volume_restore: Button = $"AudioOptions/AudioSetting/VSpilt/Master/MasterRestore"
@onready var master_volume_percent: Label = $"AudioOptions/AudioSetting/VSpilt/Master/MasterPercent"
@onready var bgm_volume: HSlider = $"AudioOptions/AudioSetting/VSpilt/Music/BgmSlider"
@onready var bgm_volume_restore: Button = $"AudioOptions/AudioSetting/VSpilt/Music/BgmRestore"
@onready var bgm_volume_percent: Label = $"AudioOptions/AudioSetting/VSpilt/Music/BgmPercent"
@onready var sfx_volume: HSlider = $"AudioOptions/AudioSetting/VSpilt/SFX/SfxSlider"
@onready var sfx_volume_restore: Button = $"AudioOptions/AudioSetting/VSpilt/SFX/SfxRestore"
@onready var sfx_volume_percent: Label = $"AudioOptions/AudioSetting/VSpilt/SFX/SfxPercent"

@onready var mouse_sen: HSlider = $"ControlOptions/ControlSetting/VSpilt/MouseSen/MouseSlider"
@onready var mouse_sen_restore: Button = $"ControlOptions/ControlSetting/VSpilt/MouseSen/MouseRestore"
@onready var mouse_sen_percent: Label = $"ControlOptions/ControlSetting/VSpilt/MouseSen/MousePercent"
@onready var auto_pickup: CheckBox = $"ControlOptions/ControlSetting/VSpilt/AutoPickup/AutoPickupCheckbox"
@onready var auto_pickup_restore: Button = $"ControlOptions/ControlSetting/VSpilt/AutoPickup/AutoPickupRestore"
@onready var keybindings_group: Button = $"ControlOptions/ControlSetting/VSpilt/KeybindingsGroup"
@onready var keybingdings_container: VBoxContainer = $"ControlOptions/ControlSetting/VSpilt/KeybindingsContainer"

signal Setsdfgi(value: bool)

func _ready() -> void:
	hint_button_comment.text = ""
	# Language
	match TranslationServer.get_locale():
		"en_US":	game_language.set_indexed("selected",0)
		"zh_CN":	game_language.set_indexed("selected",1)
	if Global.is_os_language_supported():
		game_language_restore.set_disabled(is_language_match())
	elif TranslationServer.get_locale() == "en_US":
		game_language_restore.set_disabled(false)
	# Data path
	data_path.text = Global.data_path
	data_path_restore.set_disabled(Global.data_path == "user://")
	# Use sub threads
	use_sub_threads.set_pressed_no_signal(AHL_Core.load_use_sub_threads)
	use_sub_threadsRestore.set_disabled(AHL_Core.load_use_sub_threads == false)
	# Debug
	if !debug_options_group.button_pressed:
		debug_options_container.hide()
	if !keybindings_group.button_pressed:
		keybingdings_container.hide()
	print_debug_info.set_pressed_no_signal(Global.print_debug_info)
	print_debug_info_restore.set_disabled(Global.print_debug_info == false)
	catch_p_elem_issue.set_pressed_no_signal(Global.catch_p_elem_issue)
	catch_p_elem_issue_restore.set_disabled(Global.catch_p_elem_issue == false)
	always_show_cursor.set_pressed_no_signal(Global.always_show_cursor)
	always_show_cursor_restore.set_disabled(Global.always_show_cursor == false)
	fast_boot.set_pressed_no_signal(Global.fast_boot)
	fast_boot_restore.set_disabled(Global.fast_boot == false)
	oobe.set_pressed_no_signal(Global.oobe)
	oobe_restore.set_disabled(Global.oobe == true)
	
	# fullscreen
	match DisplayServer.window_get_mode():
		0:
			fullscreen.set_pressed_no_signal(false)
			fullscreen_restore.set_disabled(true)
		3:
			fullscreen.set_pressed_no_signal(true)
	# scale
	interface_scale.value = get_window().content_scale_factor
	interface_scale_restore.set_disabled(get_window().content_scale_factor == 1)
	# SDFGI
	sdfgi.set_pressed_no_signal(Global.sdfgi)
	sdfgi_restore.set_disabled(Global.sdfgi == false)
	
	# Volume
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	master_volume_percent.text = str("%.0f" %(db_to_linear(AudioServer.get_bus_volume_db(0))*100)) + "%"
	master_volume_restore.set_disabled(AudioServer.get_bus_volume_db(0) == linear_to_db(1))
	bgm_volume.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	bgm_volume_percent.text = str("%.0f" %(db_to_linear(AudioServer.get_bus_volume_db(1))*100)) + "%"
	bgm_volume_restore.set_disabled(AudioServer.get_bus_volume_db(1) == linear_to_db(1))
	sfx_volume.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	sfx_volume_percent.text = str("%.0f" %(db_to_linear(AudioServer.get_bus_volume_db(2))*100)) + "%"
	sfx_volume_restore.set_disabled(AudioServer.get_bus_volume_db(2) == linear_to_db(1))
	
	# Control
	mouse_sen.value = Global.mouse_sens
	mouse_sen_percent.text = str("%.0f" %((Global.mouse_sens)*100)) + "%"
	mouse_sen_restore.set_disabled(Global.mouse_sens == 0.4)
	# auto_pickup
	auto_pickup.set_pressed_no_signal(Global.auto_pickup)
	auto_pickup_restore.set_disabled(Global.auto_pickup == true)

# Change tab
func _input(_event: InputEvent) -> void:
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
	game_language_restore.set_disabled(is_language_match() or (!Global.is_os_language_supported() and index == 0))
	Global.save_settings_to_file("game","language",TranslationServer.get_locale())
	Global.window_min_limit()
func is_language_match() -> bool:
	return TranslationServer.get_locale() == OS.get_locale()
func _on_language_restore_pressed() -> void:
	if Global.is_os_language_supported():
		game_language.select(Global.language_list.find(OS.get_locale()))
		_on_language_button_item_selected(Global.language_list.find(OS.get_locale()))
	else:
		game_language.select(0)
		_on_language_button_item_selected(0)
# Choose data path
func _on_datapath_button_pressed() -> void:
	path_choose.set_current_dir(Global.data_path)
	path_choose.show()
func _on_path_choose_dir_selected(dir: String) -> void:
	Global.data_path = dir
	data_path.text = dir
	Global.save_settings_to_file("game","data_path",dir)
	data_path_restore.set_disabled(Global.data_path == "user://")
func _on_datapath_restore_pressed() -> void:
	data_path_restore.set_disabled(true)
	Global.data_path = "user://"
	data_path.text = "user://"
	Global.save_settings_to_file("game","data_path","user://")
# Use sub threads to load scene
func _on_ust_button_toggled(toggled_on: bool) -> void:
	AHL_Core.load_use_sub_threads = toggled_on
	Global.save_settings_to_file("game","load_use_sub_threads",toggled_on)
	use_sub_threadsRestore.set_disabled(AHL_Core.load_use_sub_threads == false)
func _on_ust_restore_pressed() -> void:
	use_sub_threads.set_pressed(false)
# Debug
func _on_debug_opt_group_toggled(toggled_on: bool) -> void:
	if toggled_on:
		debug_options_container.show()
	else:
		debug_options_container.hide()
func _on_pdi_button_toggled(toggled_on: bool) -> void:
	Global.print_debug_info = toggled_on
	Global.save_settings_to_file("game","print_debug_info",toggled_on)
	print_debug_info_restore.set_disabled(Global.print_debug_info == false)
func _on_pdi_restore_pressed() -> void:
	print_debug_info.set_pressed(false)
func _on_cpei_button_toggled(toggled_on: bool) -> void:
	Global.catch_p_elem_issue = toggled_on
	Global.save_settings_to_file("game","catch_p_null_issue",toggled_on)
	catch_p_elem_issue_restore.set_disabled(Global.catch_p_elem_issue == false)
func _on_cpei_restore_pressed() -> void:
	catch_p_elem_issue.set_pressed(false)
func _on_asc_button_toggled(toggled_on: bool) -> void:
	Global.always_show_cursor = toggled_on
	Global.save_settings_to_file("game","always_show_cursor",toggled_on)
	always_show_cursor_restore.set_disabled(Global.always_show_cursor == false)
func _on_asc_restore_pressed() -> void:
	always_show_cursor.set_pressed(false)
# Fast Boot and oobe, only for test
func _on_fb_button_toggled(toggled_on: bool) -> void:
	Global.fast_boot = toggled_on
	Global.save_settings_to_file("computer","fast_boot",toggled_on)
	fast_boot_restore.set_disabled(Global.fast_boot == false)
func _on_fb_restore_pressed() -> void:
	fast_boot.set_pressed(false)
func _on_oobe_button_toggled(toggled_on: bool) -> void:
	Global.oobe = toggled_on
	Global.save_settings_to_file("computer","oobe",toggled_on)
	oobe_restore.set_disabled(Global.oobe == true)
func _on_oobe_restore_pressed() -> void:
	oobe.set_pressed(true)
	
func _key_debug_scene() -> void:
	AHL_LoadingScene.new_loader("res://Title/debug/KeyDebug.tscn").start_load()

# Fullscreen
func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true :
		if DisplayServer.window_get_mode() != 2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else :
		while DisplayServer.window_get_mode() != 0:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2(1600,900))
	Global.save_settings_to_file("video","fullscreen",DisplayServer.window_get_mode())
	fullscreen_restore.set_disabled(DisplayServer.window_get_mode() == 0)
func _on_fullscreen_restore_pressed() -> void:
	fullscreen.set_pressed(false)
# Scale
func _on_scale_button_value_changed(value: float) -> void:
	get_window().content_scale_factor = value
	Global.save_settings_to_file("video","scale",get_window().content_scale_factor)
	interface_scale_restore.set_disabled(get_window().content_scale_factor == 1)
func _on_scale_restore_pressed() -> void:
	interface_scale.set_value(1)
# SDFGI
func _on_sdfgi_button_toggled(toggled_on: bool) -> void:
	Global.sdfgi = toggled_on
	Setsdfgi.emit(toggled_on)
	Global.save_settings_to_file("video","sdfgi",toggled_on)
	sdfgi_restore.set_disabled(Global.sdfgi == false)
func _on_sdfgi_restore_pressed() -> void:
	sdfgi.set_pressed(false)
	
# Master volume
func _on_master_button_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
	master_volume_percent.text = str("%.0f" %(value * 100)) + "%"
	Global.save_settings_to_file("audio","master",AudioServer.get_bus_volume_db(0))
	master_volume_restore.set_disabled(AudioServer.get_bus_volume_db(0) == linear_to_db(1))
func _on_master_restore_pressed() -> void:
	master_volume.set_value(1)
# Bgm volume
func _on_bgm_button_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	bgm_volume_percent.text = str("%.0f" %(value*100)) + "%"
	Global.save_settings_to_file("audio","bgm",AudioServer.get_bus_volume_db(1))
	bgm_volume_restore.set_disabled(AudioServer.get_bus_volume_db(1) == linear_to_db(1))
func _on_bgm_restore_pressed() -> void:
	bgm_volume.set_value(1)
# Sfx volume
func _on_sfx_button_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	sfx_volume_percent.text = str("%.0f" %(value*100)) + "%"
	Global.save_settings_to_file("audio","sfx",AudioServer.get_bus_volume_db(2))
	sfx_volume_restore.set_disabled(AudioServer.get_bus_volume_db(2) == linear_to_db(1))
func _on_sfx_restore_pressed() -> void:
	sfx_volume.set_value(1)
	
# Mouse sensitivity
func _on_mouse_button_value_changed(value: float) -> void:
	Global.mouse_sens = value
	mouse_sen_percent.text = str("%.0f" %(value*100)) + "%"
	Global.save_settings_to_file("control","mouse_sens",value)
	mouse_sen_restore.set_disabled(Global.mouse_sens == 0.4)
func _on_mouse_restore_pressed() -> void:
	mouse_sen.set_value(0.4)
# auto_pickup
func _on_auto_pickup_button_toggled(toggled_on: bool) -> void:
	Global.auto_pickup = toggled_on
	Global.save_settings_to_file("control","auto_pickup",toggled_on)
	auto_pickup_restore.set_disabled(Global.auto_pickup == true)
func _on_auto_pickup_restore_pressed() -> void:
	auto_pickup.set_pressed(true)
# Keybindings
func _on_keybindings_group_toggled(toggled_on: bool) -> void:
	if toggled_on:
		keybingdings_container.show()
	else:
		keybingdings_container.hide()

func _on_tab_changed(_tab: int) -> void:
	if Global.current_menu == "Options":
		tab_focus()
func tab_focus() -> void:
	match current_tab:
		0:game_language.grab_focus()
		1:fullscreen.grab_focus()
		2:master_volume.grab_focus()
		3:mouse_sen.grab_focus()
