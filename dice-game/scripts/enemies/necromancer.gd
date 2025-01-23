extends Node

@export var heal_amount: int = 10 

func _ready() -> void:
	await get_parent().signal_attack
	if get_parent().hp != 0:
		get_parent().attack()
		get_tree().call_group("current_enemies","revive",heal_amount)
	_ready()
