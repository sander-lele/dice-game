extends Node


func _ready() -> void:
	#this is so stupid. It works, but it's so stupid
	await get_parent().signal_attack
	get_parent().queue_free()
