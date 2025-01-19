extends Node

func _ready() -> void:
	await get_parent().signal_turn_tick
	if get_parent().turn_counter <= 0:
		get_parent().attack()
		get_parent().tic_turn_counter()
		if get_parent().turn_counter == 0:
			get_parent().turn_counter = get_parent().turn_counter_start
		get_tree().call_group("current_enemies","over_heal")
	_ready()
