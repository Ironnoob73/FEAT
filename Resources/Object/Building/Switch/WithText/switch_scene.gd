@tool
extends AHL_Interactive

@onready var mesh: MeshInstance3D = $Body/Mesh
@onready var label: Label3D = $Body/Mesh/Label

@export var text: String = "[]":
	set(text_in):
		text = text_in
		if label != null:
			label.text = text_in
			
@export var auto_unlit : bool = true

func _ready() -> void:
	super._ready()
	label.text = text

func _button_interact_signal(interactor: AHL_Interactive, sender: Node) -> void:
	if is_node_ready():
		_press()
		
	if !state:
		switch(true, sender)
		
	if auto_unlit:
		await _timeout_unlit(interactor)
		
func _press() -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	var _p_tween: PropertyTweener = tween.tween_property(mesh, "position:z", 0.1, 0)
	_p_tween = tween.tween_property(mesh, "position:z", 0.15, 0.5)

func _on_state_change(state_in: bool, _s: Node) -> void:
	if label != null:
		label.shaded = !state_in
		if state_in:
			label.modulate = Color(1.0, 1.0, 0.498, 1.0)
		else:
			label.modulate = Color(1.0, 1.0, 1.0, 1.0)
			
func _timeout_unlit(interactor: AHL_Interactive) -> void:
	var timer : SceneTreeTimer
	if interactor.has_meta("timer"):
		timer = interactor.get_meta("timer")
		timer.set_time_left(0.5)
	else:
		timer = get_tree().create_timer(0.5,false,true,false)
	interactor.set_meta("timer", timer)
	await timer.timeout
	interactor.remove_meta("timer")
	interactor.switch(false, self)
