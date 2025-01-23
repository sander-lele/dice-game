extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().signal_attack
	if get_parent().dice_count < 5:
		get_parent().dice_count += 1
	_ready()
