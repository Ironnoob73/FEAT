extends Resource
class_name NoticeInfo

@export var title : String = "notice.title.default"
@export_enum("Info","Warning","Error") var type : String = "Info"
@export_color_no_alpha var bgColor : Color = Color(0.5,0.5,0.5,1)
@export_multiline var content : String = "notice.content.empty"
@export var choice : bool = false
@export var yep : String = "notice.choice.yep"
@export var nope : String = "notice.choice.nope"
