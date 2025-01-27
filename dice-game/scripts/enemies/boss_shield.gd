extends Node


# Called when the node enters the scene tree for the first time.
var count = 0
func _ready() -> void:
	await get_parent().signal_attack
	count += 1
	if (count%3) == 0:
		if get_parent().dice_count < 5:
			get_parent().dice_count += 1
	_ready()
