@tool
class_name HandHeldAnimation
extends AHL_Interactive

var tween: Tween

func MainAttack(attack_type: String = 'Light', delay: float = 0.5) -> void:
	if tween :
		tween.kill()
	var _p_tween: PropertyTweener = null
	match attack_type :
		'Light':
			tween = create_tween().set_trans(Tween.TRANS_LINEAR)
			_p_tween = tween.tween_property(self, "rotation", Vector3(deg_to_rad(-60), 0, deg_to_rad(60)), delay*0.25)
			_p_tween = tween.tween_property(self, "rotation", Vector3(0,0,0), delay*0.75).set_trans(Tween.TRANS_QUART)
		'Aimable':
			tween = create_tween().set_trans(Tween.TRANS_LINEAR)
			_p_tween = tween.tween_property(self, "rotation", Vector3(deg_to_rad(60),0,0), delay*0.25)
			_p_tween = tween.tween_property(self, "rotation", Vector3(0,0,0), delay*0.75).set_trans(Tween.TRANS_QUART)
