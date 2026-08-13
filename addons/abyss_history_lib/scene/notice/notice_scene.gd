class_name AHL_Notice
extends CanvasLayer

signal choice(result: bool)

@onready var title: Label = $Background/CenterContainer/Window/HBoxContainer/VBoxContainer/Title
@onready var info: RichTextLabel = $Background/CenterContainer/Window/HBoxContainer/VBoxContainer/Info
@onready var yep: Button = $Background/CenterContainer/Window/HBoxContainer/VBoxContainer/HBoxContainer/yep
@onready var nope: Button = $Background/CenterContainer/Window/HBoxContainer/VBoxContainer/HBoxContainer/nope
@onready var window: PanelContainer = $Background/CenterContainer/Window

@onready var info_img: Node2D = $Background/CenterContainer/Window/HBoxContainer/LeftBlank/Info
@onready var warning_img: Node2D = $Background/CenterContainer/Window/HBoxContainer/LeftBlank/Warning
@onready var error_img: Node2D = $Background/CenterContainer/Window/HBoxContainer/LeftBlank/Error

@onready var anim: AnimationPlayer = $AnimationPlayer

static func show_notice(notice_info:AHL_NoticeInfo) -> void :
	AHL_Core.is_notice_shown = true
	var notice_screen: AHL_Notice = preload("notice_scene.tscn").instantiate()
	var tree: SceneTree = Engine.get_main_loop()
	tree.get_root().add_child(notice_screen)
	notice_screen.get_notice_info(notice_info)
	
func get_notice_info(notice_info:AHL_NoticeInfo = AHL_NoticeInfo.new()) -> void:
	title.text = notice_info.title
	match notice_info.type:
		"Info":
			info_img.visible = true
			warning_img.visible = false
			error_img.visible = false
		"Warning":
			info_img.visible = false
			warning_img.visible = true
			error_img.visible = false
		"Error":
			info_img.visible = false
			warning_img.visible = false
			error_img.visible = true
	
	window.material.set_shader_parameter("color",notice_info.bgColor)
	info.text = notice_info.content
	
	yep.text = notice_info.yep
	nope.visible = notice_info.choice
	nope.text = notice_info.nope
	
	anim.play("Show")
	
func close() -> void:
	yep.disabled = true
	nope.disabled = true
	AHL_Core.is_notice_shown = false
	anim.play("Disappear")
	await Signal(anim, "animation_finished")
	self.queue_free()
	
func true_choice() -> void:
	choice.emit(true)
	await close()
	
func false_choice() -> void:
	choice.emit(false)
	await close()
