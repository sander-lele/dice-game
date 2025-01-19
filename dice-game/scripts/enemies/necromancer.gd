extends Node

@export var heal_amount: int = 10 

func _ready() -> void:
	await get_parent().signal_turn_tick
	if get_parent().turn_counter <= 0 and get_parent().hp != 0:
		get_parent().attack()
		get_parent().tic_turn_counter()
		if get_parent().turn_counter == 0:
			get_parent().turn_counter = get_parent().turn_counter_start
		get_tree().call_group("current_enemies","revive",heal_amount)
	_ready()
