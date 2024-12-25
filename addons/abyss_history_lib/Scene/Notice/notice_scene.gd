extends CanvasLayer

@onready var title: Label = $Background/CenterContainer/Window/HBoxContainer/VBoxContainer/Title
@onready var info: RichTextLabel = $Background/CenterContainer/Window/HBoxContainer/VBoxContainer/Info
@onready var yep: Button = $Background/CenterContainer/Window/HBoxContainer/VBoxContainer/HBoxContainer/yep
@onready var nope: Button = $Background/CenterContainer/Window/HBoxContainer/VBoxContainer/HBoxContainer/nope
@onready var window: PanelContainer = $Background/CenterContainer/Window

@onready var info_img: Node2D = $Background/CenterContainer/Window/HBoxContainer/LeftBlank/Info

@onready var anim: AnimationPlayer = $AnimationPlayer

func get_notice_info(notice_info:AHL_NoticeInfo) -> void:
	title.text = notice_info.title
	match notice_info.type:
		"Info":
			info_img.visible = true
			info_img.play()
	
	window.material.set_shader_parameter("color",notice_info.bgColor)
	info.text = notice_info.content
	
	yep.text = notice_info.yep
	nope.visible = notice_info.choice
	nope.text = notice_info.nope
	
	anim.play("Show")
	
func close() -> void:
	yep.disabled = true
	nope.disabled = true
	anim.play("Disappear")
	await Signal(anim, "animation_finished")
	self.queue_free()
	
func true_choice() -> void:
	close()
	
func false_choice() -> void:
	close()
