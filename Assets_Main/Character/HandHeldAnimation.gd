extends Marker3D
var tween
func MainAttack(attack_type: String = 'Light', delay: float = 0.5):
	if tween : tween.kill()
	print(attack_type)
	if attack_type == 'Light':
		tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self,"rotation",Vector3(deg_to_rad(-60),0,deg_to_rad(60)),delay)
		tween.tween_property(self,"rotation",Vector3(0,0,0),0.5).set_trans(Tween.TRANS_QUART)