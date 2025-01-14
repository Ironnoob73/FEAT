extends Control

@onready var bar: ProgressBar = $Background/HBox/Bar
@onready var remain: Label = $Background/HBox/Bar/Info/Remain
@onready var progress: Label = $Background/HBox/Bar/Info/Progress

func _process(delta: float) -> void:
	bar.max_value = get_parent().MaxHealth
	bar.value = get_parent().current_health
	remain.text = str(get_parent().current_health) + "/" + str(get_parent().MaxHealth)
	progress.text = str((get_parent().current_health / get_parent().MaxHealth)*100) + "%"
