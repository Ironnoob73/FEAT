extends TextureRect

@onready var interface: VBoxContainer = $VBoxContainer
@onready var page_button: MarginContainer = $VBoxContainer/DownBoard/PageButton

@onready var contents: MarginContainer = $VBoxContainer/Contents

@onready var welocme_page: VBoxContainer = $VBoxContainer/Contents/WelocmePage
@onready var language_button: Button = $VBoxContainer/Contents/WelocmePage/OptionButton
@onready var language_choose: PanelContainer = $VBoxContainer/Contents/WelocmePage/OptionButton/PanelContainer
var isLanguagePanelFocused: bool = false

@onready var name_page: VBoxContainer = $VBoxContainer/Contents/NamePage
@onready var name_edit: LineEdit = $VBoxContainer/Contents/NamePage/LineEdit
@onready var uid: Label = $VBoxContainer/Contents/NamePage/UID

@onready var avatar_page: VBoxContainer = $VBoxContainer/Contents/AvatarPage
@onready var main_avatar: Button = $VBoxContainer/Contents/AvatarPage/HBoxContainer/MainAvatar
@onready var avatar_list: HFlowContainer = $VBoxContainer/Contents/AvatarPage/HBoxContainer/ScrollContainer/AvatarList

@onready var ready_page: VBoxContainer = $VBoxContainer/Contents/ReadyPage

@onready var previous_icon: Button = $VBoxContainer/DownBoard/PageButton/HBoxContainer/PreviousIcon
@onready var previous_text: LinkButton = $VBoxContainer/DownBoard/PageButton/HBoxContainer/PreviousText
@onready var next_text: LinkButton = $VBoxContainer/DownBoard/PageButton/HBoxContainer/NextText

var page_number: int = 0:
	set(number):
		page_number = number
		if page_number < 0:
			page_number = 0
		_change_page(page_number)

func _ready() -> void:
	hide()
	interface.hide()
	page_button.hide()
	for i in contents.get_children():
		i.hide()
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func():show()).set_delay(1)
	tween.tween_callback(func():interface.show()).set_delay(0.5)
	tween.tween_callback(func():welocme_page.show()).set_delay(0.5)
	tween.tween_callback(func():page_button.show()).set_delay(0.1)
	
	match_language()
	Global.duid = Global.generate_duid()
	avatar_init()

func _change_page(number: int):
	for i in contents.get_children():
		i.hide()
	previous_icon.visible = number != 0
	previous_text.visible = number != 0
	if page_number != 3:
		next_text.text = "button.next_step"
	else:
		next_text.text = "button.done"
		
	
	match page_number:
		1:
			name_page.show()
			uid.text = tr("oobe.name.uid") % Global.duid
		2:
			avatar_page.show()
			var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
			for i in avatar_list.get_children():
				tween.tween_callback(func():i.show()).set_delay(0.1)
		3:ready_page.show()
		4:
			Global.oobe = false
			Global.FastBoot = false
			get_parent().ready_desktop()
			Global.save_config()
			queue_free()
		_:welocme_page.show()

func _on_previous_pressed() -> void:
	page_number -= 1
func _on_next_pressed() -> void:
	page_number += 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton\
	and event.button_index == 1\
	and event.is_pressed\
	and !isLanguagePanelFocused and language_choose.visible == true:
		_on_language_pressed()
	
# Welcome & Language
func match_language() -> void:
	match TranslationServer.get_locale():
		"en_US":	language_button.text = "English"
		"zh_CN":	language_button.text = "中文"
func _on_language_pressed() -> void:
	if language_choose.visible != true:
		language_button.icon = preload("res://Resources/Image/UI/UpArrow.svg")
		language_choose.show()
	else:
		language_button.icon = preload("res://Resources/Image/UI/DownArrow.svg")
		language_choose.hide()
func _on_english_button_pressed() -> void:
	language_button.text = "English"
	TranslationServer.set_locale("en_US")
	_on_language_pressed()
func _on_mandarin_button_pressed() -> void:
	language_button.text = "中文"
	TranslationServer.set_locale("zh_CN")
	_on_language_pressed()
func _on_language_panel_entered() -> void:
	isLanguagePanelFocused = true
func _on_language_panel_exited() -> void:
	isLanguagePanelFocused = false
	
# User name
func _on_user_name_text_changed(new_text: String) -> void:
	if new_text != "":
		Global.playerName = new_text
	else:
		Global.playerName = "Anonymous"

# Avatar
func avatar_init() -> void:
	for i in avatar_list.get_children():
		if i is Button:
			i.connect("pressed", func():change_avatar(i.icon))
			i.hide()
func change_avatar(image: Texture2D) -> void:
	main_avatar.icon = image
	Global.avatar = image
# Dog: https://pixabay.com/zh/photos/labrador-dog-animal-brown-fur-5762115/
# Cat: https://pixabay.com/zh/photos/cat-grace-animals-kitten-house-cat-5001517/
# Mountain: https://pixabay.com/zh/photos/cholatse-nepal-mountain-2875106/
# Structure: https://pixabay.com/zh/photos/architecture-skyscrapers-windows-7549184/
