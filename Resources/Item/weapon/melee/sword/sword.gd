extends MeshInstance3D

var idle : bool = false
var sec : bool = false

func _ready():
	self.position.y = -1
	self.position.x = 1
	self.rotation_degrees.z = 45
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self, "position:y", 0, 0.5)
	tween.tween_property(self, "position:x", 0, 0.5)
	tween.tween_property(self, "rotation_degrees:z", 0, 0.5)
	tween.tween_property(self, "idle", true, 0).set_delay(0.5)

func main_attack(press:bool):
	if press == true && idle == true && sec == false:
		idle = false
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "rotation_degrees:y", 70, 0.1)
		tween.tween_property(self, "rotation_degrees:z", 70, 0.1)
		tween.tween_property(self, "rotation_degrees:z", 0, 0.5)
		tween.tween_property(self, "idle", true, 0)
		get_parent().get_parent().attack()
		
func secondary_attack(press:bool):
	if press == true && idle == true :
		sec = true
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		tween.tween_property(self, "rotation_degrees:y", 70, 0.1)
		tween.tween_property(self, "rotation_degrees:z", 70, 0.1)
	elif press == false && idle == true :
		sec = false
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		tween.tween_property(self, "rotation_degrees:y", 0, 0.1)
		tween.tween_property(self, "rotation_degrees:z", 0, 0.1)
	
