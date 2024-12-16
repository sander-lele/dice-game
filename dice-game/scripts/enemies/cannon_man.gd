extends Node

func _ready() -> void:
	#this is so stupid. It works, but it's so stupid
	await get_parent().signal_hit
	get_parent().turn_counter = get_parent().turn_counter_start+1
	_ready()
