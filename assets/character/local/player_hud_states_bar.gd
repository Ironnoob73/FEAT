extends Control

@onready var bar: ProgressBar = $Background/HBox/Bar
@onready var remain: Label = $Background/HBox/Bar/Info/Remain
@onready var progress: Label = $Background/HBox/Bar/Info/Progress

func _process(_delta: float) -> void:
	var player: LocalPlayer = get_parent()
	bar.max_value = player.max_health
	bar.value = player.current_health
	remain.text = str(player.current_health) + "/" + str(player.max_health)
	progress.text = str((player.current_health / player.max_health)*100) + "%"
