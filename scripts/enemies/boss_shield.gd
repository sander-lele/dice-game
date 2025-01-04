extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().signal_turn_tick
	if get_parent().dice_count < 6:
		get_parent().dice_count += 1
	_ready()
