extends Node

var heal_amount = 10

func _ready() -> void:
	await get_parent().signal_attack
	if get_parent().hp != 0:
		get_parent().attack()
		get_tree().call_group("current_enemies","heal")
	_ready()
