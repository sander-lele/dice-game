extends Node

func _ready() -> void:
	await get_parent().signal_turn_tick
	if get_parent().turn_counter <= 0:
		get_parent().tic_turn_counter()
		get_tree().call_group("current_enemies","over_heal")
	_ready()
