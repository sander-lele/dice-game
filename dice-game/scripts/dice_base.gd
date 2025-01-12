extends TextureRect



func bump():
	var tween = create_tween()
	var posy = 5
	tween.tween_property(self,"position:y",position.y+posy,0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"position:y",-posy,0.1).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
