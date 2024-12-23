extends Marker3D
var tween
func MainAttack(attack_type: String = 'Light', delay: float = 0.5):
	if tween : tween.kill()
	match attack_type :
		'Light':
			tween = create_tween().set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(self,"rotation",Vector3(deg_to_rad(-60),0,deg_to_rad(60)),delay*0.25)
			tween.tween_property(self,"rotation",Vector3(0,0,0),delay*0.75).set_trans(Tween.TRANS_QUART)
		'Aimable':
			tween = create_tween().set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(self,"rotation",Vector3(deg_to_rad(60),0,0),delay*0.25)
			tween.tween_property(self,"rotation",Vector3(0,0,0),delay*0.75).set_trans(Tween.TRANS_QUART)
