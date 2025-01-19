extends Node

@export var is_boss = false

func _ready() -> void:
	#this is so stupid. It works, but it's so stupid
	await get_parent().signal_attack
	get_parent().hp = 0
	get_parent().die()


func _on_bomb_signal_turn_tick() -> void:
	var turn = get_parent().turn_counter
	if turn != 0 and get_parent().hp != 0:
		if is_boss == false:
			$"../sprite".texture = load("res://assets/bomb" + str(turn) + ".png")
		elif is_boss == true:
			$"../sprite".texture = load("res://assets/bossbomb" +str(turn)+ ".png")
