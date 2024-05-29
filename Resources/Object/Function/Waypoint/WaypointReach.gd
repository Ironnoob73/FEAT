extends Area3D

var _touched : bool = false
signal touch

func _on_body_entered(_body):
	if !_touched:
		$Mesh.hide()
		$GPUParticles3D.restart()
		_touched = true
		emit_signal("touch")

func reactive():
	_touched = false
	$Mesh.show()
