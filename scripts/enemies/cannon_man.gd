extends Node

@export var turn_counter_set_back = 3

func _ready() -> void:
	#this is so stupid. It works, but it's so stupid
	await get_parent().signal_hit
	get_parent().turn_counter = get_parent().turn_counter_start+1
	_ready()
